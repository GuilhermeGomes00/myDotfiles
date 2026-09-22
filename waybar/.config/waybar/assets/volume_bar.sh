#!/bin/bash

while true; do
    # Get volume and mute status
    output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)

    # Parse volume
    volume=$(awk -v out="$output" 'BEGIN { split(out, a, " "); printf "%.0f\n", a[2] * 100 }')

    # Check for MUTE tag (faster)
    if [[ "$output" == *"[MUTED]"* ]]; then
      muted="yes"
    else
      muted="no"
    fi

    if [ "$muted" = "yes" ]; then
      BAR=" " # Mute icon
    else
      BAR=" " # Volume icon
    fi

    # Output JSON for Waybar
    echo "{\"text\": \"$BAR\", \"tooltip\": \"Volume: ${volume}%\", \"class\": \"custom-wireplumber\"}"
	sleep 2
done
