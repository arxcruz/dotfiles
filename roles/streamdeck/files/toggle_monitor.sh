#!/bin/bash

# Monitor Definitions
G9_CONN="DP-1"
G9_MODE="5120x1440@239.999"

G8_CONN="HDMI-1"
G8_MODE="3840x2160@60.000"

TARGET=$1

if [[ "$TARGET" != "g8" && "$TARGET" != "g9" && "$TARGET" != "all" ]]; then
    echo "Usage: $0 [g8|g9|all]"
    exit 1
fi

# Detect current state (look for connector in the Logical monitors section)
G9_ACTIVE=$(gdctl show | sed -n '/Logical monitors:/,$p' | grep -c "$G9_CONN")
G8_ACTIVE=$(gdctl show | sed -n '/Logical monitors:/,$p' | grep -c "$G8_CONN")

if [[ "$TARGET" == "all" ]]; then
    echo "Turning BOTH monitors ON..."
    gdctl set \
        --logical-monitor --monitor "$G9_CONN" --mode "$G9_MODE" --primary \
        --logical-monitor --monitor "$G8_CONN" --mode "$G8_MODE" --right-of "$G9_CONN"
elif [[ "$TARGET" == "g8" ]]; then
    if [[ "$G8_ACTIVE" -gt 0 ]]; then
        # G8 is ON, turn it OFF. We must keep G9 ON.
        if [[ "$G9_ACTIVE" -eq 0 ]]; then
            echo "G8 is the only monitor active. Switching to G9 instead of just turning it off..."
            gdctl set --logical-monitor --monitor "$G9_CONN" --mode "$G9_MODE" --primary
        else
            echo "Turning G8 OFF..."
            gdctl set --logical-monitor --monitor "$G9_CONN" --mode "$G9_MODE" --primary
        fi
    else
        # G8 is OFF, turn it ON.
        echo "Turning G8 ON..."
        if [[ "$G9_ACTIVE" -gt 0 ]]; then
            # Keep G9 as primary
            gdctl set \
                --logical-monitor --monitor "$G9_CONN" --mode "$G9_MODE" --primary \
                --logical-monitor --monitor "$G8_CONN" --mode "$G8_MODE" --right-of "$G9_CONN"
        else
            # Only G8
            gdctl set --logical-monitor --monitor "$G8_CONN" --mode "$G8_MODE" --primary
        fi
    fi
elif [[ "$TARGET" == "g9" ]]; then
    if [[ "$G9_ACTIVE" -gt 0 ]]; then
        # G9 is ON, turn it OFF.
        if [[ "$G8_ACTIVE" -eq 0 ]]; then
             echo "G9 is the only monitor active. Switching to G8 instead..."
             gdctl set --logical-monitor --monitor "$G8_CONN" --mode "$G8_MODE" --primary
        else
             echo "Turning G9 OFF (G8 becomes primary)..."
             gdctl set --logical-monitor --monitor "$G8_CONN" --mode "$G8_MODE" --primary
        fi
    else
        # G9 is OFF, turn it ON.
        echo "Turning G9 ON..."
        if [[ "$G8_ACTIVE" -gt 0 ]]; then
             # Make G9 primary and keep G8
             gdctl set \
                --logical-monitor --monitor "$G9_CONN" --mode "$G9_MODE" --primary \
                --logical-monitor --monitor "$G8_CONN" --mode "$G8_MODE" --right-of "$G9_CONN"
        else
             gdctl set --logical-monitor --monitor "$G9_CONN" --mode "$G9_MODE" --primary
        fi
    fi
fi
