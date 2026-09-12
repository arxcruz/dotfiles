#!/bin/bash
set -euo pipefail

# ─── ANSI Helpers ─────────────────────────────────────────────────────────────
R="\033[0m"          # Reset
CYAN='\033[36m'
GREEN='\033[32m'
DIM_GREEN='\033[2;32m'
RED='\033[31m'
YELLOW='\033[33m'
DIM='\033[2m'
B=""   # no bold in the original palette
I=""   # no italic in the original palette

# Aliases so the rest of the script reads the same as before
FG_GRAY="$DIM"
FG_RED="$RED"
FG_BRIGHT_RED="$RED"
FG_BRIGHT_GREEN="$GREEN"
FG_BRIGHT_YELLOW="$YELLOW"
FG_BRIGHT_BLUE="$CYAN"
FG_BRIGHT_MAGENTA="$CYAN"
FG_BRIGHT_CYAN="$CYAN"
FG_BRIGHT_WHITE=""

# Number Highlight Color
NUM_COLOR=""

# ─── Parse JSON from stdin (single jq pass for performance) ──────────────────
input=$(cat)

{
  read -r MODEL
  read -r CWD
  read -r USED_PCT
  read -r COST
  read -r DURATION_MS
  read -r LINES_ADDED
  read -r LINES_REMOVED
  read -r OUTPUT_STYLE
  read -r EFFORT
  read -r FAST_MODE
  read -r FIVE_H_PCT
  read -r SEVEN_D_PCT
  read -r INPUT_TOKENS
  read -r OUTPUT_TOKENS
  read -r _END_MARKER
} <<< "$(
  echo "$input" | jq -r '
    (.model.display_name // ""),
    (.workspace.current_dir // .cwd // ""),
    (.context_window.used_percentage // 0),
    (.cost.total_cost_usd // 0),
    (.cost.total_duration_ms // 0),
    (.cost.total_lines_added // 0),
    (.cost.total_lines_removed // 0),
    (.output_style.name // ""),
    (.effort.level // ""),
    (.fast_mode // false),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.seven_day.used_percentage // ""),
    (.context_window.total_input_tokens // 0),
    (.context_window.total_output_tokens // 0),
    "END"
  ' 2>/dev/null || printf "\n\n0\n0\n0\n0\n0\n\n\nfalse\n\n\n0\n0\nEND\n"
)"

DIR=$(basename "${CWD:-$PWD}")

# ─── Computed Values ─────────────────────────────────────────────────────────
# Use LC_NUMERIC=C to prevent bash printf errors in locales that use commas for decimals
PCT_FMT=$(LC_NUMERIC=C printf "%.1f" "$USED_PCT")
PCT_INT=${USED_PCT%.*}; PCT_INT=${PCT_INT:-0}

COLS="${COLUMNS:-80}"

# ─── Git branch + dirty state ────────────────────────────────────────────────
BRANCH=""
DIRTY="false"
if [ -n "$CWD" ] && git -C "$CWD" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  BRANCH=$(git -C "$CWD" --no-optional-locks branch --show-current 2>/dev/null)
  if [ -n "$(git -C "$CWD" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
    DIRTY="true"
  fi
fi

V=""
if [ -n "$BRANCH" ]; then
  if [ "$DIRTY" = "true" ]; then
    V="${DIM} | ${R}\xf0\x9f\x8c\xbf ${YELLOW}${BRANCH}*${R}"
  else
    V="${DIM} | ${R}\xf0\x9f\x8c\xbf ${GREEN}${BRANCH}${R}"
  fi
fi

# ─── Model ───────────────────────────────────────────────────────────────────
M=""
if [ -n "$MODEL" ]; then
  M="${CYAN}[${MODEL}]${R}"
fi

# ─── Effort / fast-mode badge (state indicator) ──────────────────────────────
if [ "$FAST_MODE" = "true" ]; then
  S="${CYAN}⚡ FAST${R}"
else
  case "$EFFORT" in
    low)    S="${GREEN}● LOW${R}" ;;
    medium) S="${YELLOW}◆ MEDIUM${R}" ;;
    high)   S="${YELLOW}◆ HIGH${R}" ;;
    xhigh)  S="${RED}◆ XHIGH${R}" ;;
    max)    S="${RED}★ MAX${R}" ;;
    *)      S="${GREEN}● READY${R}" ;;
  esac
fi

# ─── Context Bar (15 segments, fine-grain Unicode) ────────────────────────────
BAR_LEN=15
FILLED=$((PCT_INT * BAR_LEN / 100))
REMAINDER=$(( (PCT_INT * BAR_LEN) % 100 ))

if [ "$PCT_INT" -ge 90 ]; then
  BAR_COLOR="$RED"
elif [ "$PCT_INT" -ge 60 ]; then
  BAR_COLOR="$YELLOW"
else
  BAR_COLOR="$GREEN"
fi

BAR=""
EMPTY_STARTED=0
for ((i = 0; i < BAR_LEN; i++)); do
  if [ "$i" -lt "$FILLED" ]; then
    BAR="${BAR}█"
  elif [ "$i" -eq "$FILLED" ]; then
    EMPTY_STARTED=1
    if [ "$REMAINDER" -ge 75 ]; then
      BAR="${BAR}▓"
    elif [ "$REMAINDER" -ge 50 ]; then
      BAR="${BAR}▒"
    elif [ "$REMAINDER" -ge 25 ]; then
      BAR="${BAR}░"
    else
      BAR="${BAR}${DIM_GREEN}·"
    fi
  else
    [ "$EMPTY_STARTED" -eq 0 ] && BAR="${BAR}${DIM_GREEN}"
    EMPTY_STARTED=1
    BAR="${BAR}·"
  fi
done

# ─── Stats ───────────────────────────────────────────────────────────────────
COST_STR=$(LC_NUMERIC=C printf "\$%.2f" "$COST")
DURATION_MS=${DURATION_MS%.*}; DURATION_MS=${DURATION_MS:-0}
DURATION_S=$(( DURATION_MS / 1000 ))
MINUTES=$(( DURATION_S / 60 ))
SECONDS=$(( DURATION_S % 60 ))
DURATION_STR="${MINUTES}m ${SECONDS}s"

TOTAL_TOKENS=$(( ${INPUT_TOKENS%.*} + ${OUTPUT_TOKENS%.*} ))
TOKENS_STR=$(awk -v n="$TOTAL_TOKENS" 'BEGIN { printf "%.1fk", n / 1000 }')
TOKENS_FMT="${YELLOW}${TOKENS_STR}${R} tok"

CTX="${BAR_COLOR}${BAR}${R} ${PCT_FMT}%"
COST_FMT="${YELLOW}${COST_STR}${R}"
TIME_FMT="\xf0\x9f\x95\x90 ${DURATION_STR}"
DIFF_FMT="${GREEN}+${LINES_ADDED}${R}${DIM}/${R}${RED}-${LINES_REMOVED}${R}"

RATE_FMT=""
if [ -n "$FIVE_H_PCT" ]; then
  RATE_FMT="5h $(LC_NUMERIC=C printf "%.0f" "$FIVE_H_PCT")%"
fi
if [ -n "$SEVEN_D_PCT" ]; then
  SEVEN_FMT="7d $(LC_NUMERIC=C printf "%.0f" "$SEVEN_D_PCT")%"
  RATE_FMT="${RATE_FMT:+$RATE_FMT }${SEVEN_FMT}"
fi

STYLE_FMT=""
if [ -n "$OUTPUT_STYLE" ] && [ "$OUTPUT_STYLE" != "default" ]; then
  STYLE_FMT="style ${OUTPUT_STYLE}"
fi

# ─── Separators ──────────────────────────────────────────────────────────────
DOT="${DIM} | ${R}"

# ─── Output ──────────────────────────────────────────────────────────────────
LINE1="${S} ${M} \xf0\x9f\x93\x81 ${DIR}${V}"

LINE2_PARTS=("$CTX" "$TOKENS_FMT" "$COST_FMT" "$TIME_FMT" "$DIFF_FMT")
[ -n "$RATE_FMT" ] && LINE2_PARTS+=("$RATE_FMT")
[ -n "$STYLE_FMT" ] && LINE2_PARTS+=("$STYLE_FMT")

LINE2=""
for part in "${LINE2_PARTS[@]}"; do
  if [ -z "$LINE2" ]; then
    LINE2=" ${part}"
  else
    LINE2="${LINE2}${DOT}${part}"
  fi
done

if [ "$COLS" -ge 80 ]; then
  # Two-line layout with border
  echo -e "${FG_GRAY}╭─${R} ${LINE1}"
  echo -e "${FG_GRAY}╰─${R}${LINE2}"
else
  # Narrow: compact two-line, minimal chrome
  echo -e "${S}${M}"
  echo -e "${CTX}${DOT}${TOKENS_FMT}${DOT}${COST_FMT}"
fi
