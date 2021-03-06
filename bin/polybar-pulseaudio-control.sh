#!/usr/bin/env bash

VOL_INC=2
VOL_MAX=130

declare -A SINK_NICKNAMES
SINK_NICKNAMES[alsa_output.usb-*.analog-stereo]="🎧 (usb)"
SINK_NICKNAMES[alsa_output.pci-0000_00_??.?.analog-stereo]="🔊 (built-in/analog)"
SINK_NICKNAMES[alsa_output.pci-0000_00_??.?.hdmi-stereo]=" (built-in/hdmi)"
SINK_NICKNAMES[bluez_sink.??_??_??_??_??_??.headset_head_unit]="🎧 (headset)"
SINK_NICKNAMES[bluez_sink.??_??_??_??_??_??.a2dp_sink_aac]="🎧 (a2dp/aac)"
SINK_NICKNAMES[bluez_sink.??_??_??_??_??_??.a2dp_sink_sbc]="🎧 (a2dp/sbc)"
SINK_NICKNAMES[bluez_sink.??_??_??_??_??_??.a2dp_sink]="🎧 (a2dp)"

#SINK_NICKNAMES[alsa_output.usb-*.analog-stereo]=""
#SINK_NICKNAMES[alsa_output.pci-0000_00_??.?.analog-stereo]="🔊"
#SINK_NICKNAMES[alsa_output.pci-0000_00_??.?.hdmi-stereo]=""
#SINK_NICKNAMES[bluez_sink.??_??_??_??_??_??.headset_head_unit]="🎧"
#SINK_NICKNAMES[bluez_sink.??_??_??_??_??_??.a2dp_sink]="🎧"
#SINK_NICKNAMES[bluez_sink.??_??_??_??_??_??.a2dp_sink_aac]="🎧"
#SINK_NICKNAMES[bluez_sink.??_??_??_??_??_??.a2dp_sink_sbc]="🎧"

SINK_NICKNAMES[alsa_output.usb-*.analog-stereo]=""
SINK_NICKNAMES[alsa_output.pci-0000_00_??.?.analog-stereo]="🔊"
SINK_NICKNAMES[alsa_output.pci-0000_00_??.?.hdmi-stereo]=""
SINK_NICKNAMES[bluez_sink.??_??_??_??_??_??.headset_head_unit]=""
SINK_NICKNAMES[bluez_sink.??_??_??_??_??_??.a2dp_sink]="🎧"

if ! pulseaudio --check; then
    echo "No pulseaudio" >&2
    exit 0;
fi

SELECTED_SINK=$(pacmd list-sinks | awk '/\* index:/{print $3}')
SELECTED_SINK_NAME=$(pactl list sinks short | awk -v sink="${SELECTED_SINK}" '{ if ($1 == sink) {print $2} }')
VOLUME=$(pacmd list-sinks | grep -A 15 'index: '"$SELECTED_SINK"'' | grep 'volume:' | grep -E -v 'base volume:' | awk -F : '{print $3; exit}' | grep -o -P '.{0,3}%' | sed s/.$// | tr -d ' ')
VOLUME_UP=$((VOLUME + VOL_INC))
VOLUME_UP=$((VOLUME_UP > VOL_MAX ? VOL_MAX : VOLUME_UP))
VOLUME_DOWN=$((VOLUME - VOL_INC))
VOLUME_DOWN=$((VOLUME_DOWN < 0 ? 0 : VOLUME_DOWN))
MUTED=$(pacmd list-sinks | grep -A 15 "index: $SELECTED_SINK" | awk '/muted/{print $2}')


output() {
    local icon="🔊? "
    for match in "${!SINK_NICKNAMES[@]}"; do
        case $SELECTED_SINK_NAME in
            $match) icon=${SINK_NICKNAMES[$match]} ;;
        esac
    done
    if [ "$MUTED" == "yes" ]; then
        echo -n "%{F#6b6b6b}${icon}  ${VOLUME}%%{F-}"
    else
        echo -n "${icon}  ${VOLUME}%"
    fi

    glyphs="ﴐﴆﴇﴈﴉﴊﴋﴌﴍﴎﴅ"
    color_0="%{F#cc0033}"
    color_1="%{F#ffb52a}"
    color_2="%{F#ffb52a}"
    color_7="%{F#009966}"
    color_8="%{F#009966}"

    headset_connected=$(bluetoothctl info 4C:87:5D:06:32:13 | grep "Connected: yes")

    if [ "$headset_connected" ] ; then
        headset_file="$HOME/.headset-last-vol"

        vol=$(cat $headset_file 2>/dev/null)
        if [ "$vol" ]; then
            i=$(($vol * ${#glyphs} / 100))
            [ "$i" -eq 0 ] && i=8
            glyph=${glyphs:$i:1}
            color=$(eval echo '$color_'$i)
            echo -n "$color  $glyph ${vol}%%{F-}"
        fi
        if [ -f $headset_file ]; then
            changed_since_minutes=$(( ($(date +%s) - $(stat $headset_file -c %Y)) / 60 ))
        else
            changed_since_minutes=100
        fi
        if [ "$changed_since_minutes" -gt 10 ]; then
            based-connect -b 4C:87:5D:06:32:13 2>/dev/null > $headset_file &
        fi
    fi

    echo
}

function listen() {
    pkill pactl
    LANG=en_US pactl subscribe 2>/dev/null | while read -r event ; do
        need_refresh=$(echo "$event" | grep -e "on card" -e "on sink" -e "on server")
        [ "$need_refresh" ] && $0 output
    done
    exec $0 listen
}

case "$1" in
    volume-up) pactl set-sink-volume "${SELECTED_SINK}" "${VOLUME_UP}%" ;;
    volume-down) pactl set-sink-volume "${SELECTED_SINK}" "${VOLUME_DOWN}%" ;;
    toggle-mute)
        case $MUTED in
            yes) pactl set-sink-mute "${SELECTED_SINK}" "no" ;;
            no) pactl set-sink-mute "${SELECTED_SINK}" "yes" ;;
        esac
        ;;
    output) output ;;
    listen) output ; listen ;;
esac
