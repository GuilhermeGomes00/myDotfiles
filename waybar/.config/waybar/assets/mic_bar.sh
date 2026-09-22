#!/bin/bash

while true; do
    # Get microphone volume and mute status
    output=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)

    # Parse volume
    volume=$(awk -v out="$output" 'BEGIN { split(out, a, " "); printf "%.0f\n", a[2] * 100 }')

    # Check for MUTE tag (faster)
    if [[ "$output" == *"[MUTED]"* ]]; then
      muted="yes"
    else
      muted="no"
    fi

    if [ "$muted" = "yes" ]; then
      BAR=" " # Mic muted
    else
      BAR="" # Mic on
    fi

    # Output JSON for Waybar
    echo "{\"text\": \"$BAR\", \"tooltip\": \"Microfone: ${volume}%\", \"class\": \"custom-microphone\"}"
	sleep 1
done
