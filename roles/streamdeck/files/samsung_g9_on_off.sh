#!/bin/bash

DEVICE_ID="73df75a2-b985-5684-7dd0-ab76c18f5e20"

# Get the current input source
INPUT_SOURCE=$(smartthings devices:component-status "$DEVICE_ID" -j | jq -r '.["samsungvd.mediaInputSource"].inputSource.value')

# Echo the source based on the output
case "$INPUT_SOURCE" in
    "HDMI1")
        smartthings devices:commands "$DEVICE_ID" 'samsungvd.mediaInputSource:setInputSource("Display Port")'
        ;;
    "Display Port")
        smartthings devices:commands "$DEVICE_ID" 'samsungvd.mediaInputSource:setInputSource("HDMI1")'
        ;;
    *)
        echo "$INPUT_SOURCE"
        ;;
esac
