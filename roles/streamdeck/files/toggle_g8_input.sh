#!/bin/bash

# Dynamically find the display number for Odyssey G81SF
# We look for the "Display" line immediately preceding the G8 model name
DISPLAY_NUM=$(ddcutil detect | grep -B 5 "Odyssey G81SF" | grep "Display" | awk '{print $2}')

if [ -z "$DISPLAY_NUM" ]; then
    echo "Error: Odyssey G81SF monitor not found via ddcutil detect."
    exit 1
fi

echo "Found Odyssey G81SF at ddcutil display $DISPLAY_NUM"

# Get current input source hex value
CURRENT_VAL=$(ddcutil --display "$DISPLAY_NUM" getvcp 60 | grep -oP 'sl=\K0x[0-9a-fA-F]+')

if [ -z "$CURRENT_VAL" ]; then
    echo "Error: Could not retrieve current input source for display $DISPLAY_NUM."
    exit 1
fi

echo "Current input value: $CURRENT_VAL"

if [[ "$CURRENT_VAL" == "0x0f" ]]; then
    echo "Switching G8 to HDMI (0x11)..."
    ddcutil --display "$DISPLAY_NUM" setvcp 60 17
elif [[ "$CURRENT_VAL" == "0x11" ]]; then
    echo "Switching G8 to DisplayPort (0x0f)..."
    ddcutil --display "$DISPLAY_NUM" setvcp 60 15
else
    echo "Unknown or unsupported input value: $CURRENT_VAL"
    exit 1
fi
