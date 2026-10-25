#!/bin/sh
# Copiado em comportamento do atalho de microfone no Hyprland.
# Muta/desmuta o microfone padrao e reproduz o som correspondente.
wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle || exit 1
if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; then
    sound="$HOME/.local/share/soundsmic/mute/microphone-muted-teamspeak.mp3"
else
    sound="$HOME/.local/share/soundsmic/unmute/microphone-activated-teamspeak.mp3"
fi
if [ -f "$sound" ] && command -v mpv >/dev/null 2>&1; then
    mpv --no-video --volume=50 "$sound" >/dev/null 2>&1 &
fi
