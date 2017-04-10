#!/home/sileht/.i3/venv/bin/python
# -*- coding: utf-8 -*-

from i3pystatus.mail import imap
from i3pystatus import Status

status = Status(logfile='/home/sileht/.i3pystatus.log')
status.register("clock", format="%a %b %d, %H:%M")
status.register("pulseaudio",
                on_leftclick="change_sink",
                on_middleclick="pavucontrol -t 1",
                sink="alsa_output.pci-0000_00_1f.3.analog-stereo",
                color_muted="#AAAAAA",
                format="🔊: {volume}{selected}")
status.register("pulseaudio",
                on_leftclick="change_sink",
                on_middleclick="pavucontrol -t 1",
                sink="alsa_output.pci-0000_00_1b.0.analog-stereo",
                color_muted="#AAAAAA",
                format="🔊: {volume}{selected}")
status.register("pulseaudio",
                on_leftclick="change_sink",
                on_middleclick="pavucontrol -t 1",
                sink=("alsa_output.usb-C-Media_Electronics_Inc._USB_Advanced_"
                      "Audio_Device-00.analog-stereo"),
                color_muted="#AAAAAA",
                format="🎧: {volume}{selected}")
status.register("pulseaudio",
                on_leftclick="change_sink",
                on_middleclick="pavucontrol -t 1",
                sink="bluez_sink.C0_7A_A5_00_9F_1A",
                color_muted="#AAAAAA",
                format="📡: {volume}{selected}")
status.register("cpu_usage_graph", graph_width=5)
status.register("mem_bar")
status.register("temp")
status.register("battery", interval=60, alert_percentage=3,
                # {bar}",
                format="{status}{remaining:%E%hh:%Mm} {consumption}W",
                alert=True,
                status={"DIS": "↓", "CHR": "↑", "FULL": "="},
                not_present_text="")
status.register("redshift")
status.register("mail",
                hide_if_null=False,
                backends=[imap.IMAP(host="mx1.sileht.net")],
                format_plural="{unread} new emails",
                on_leftclick="chromium https://m.sileht.net/")
status.register("shell", command="/home/sileht/.i3/vpn-chk.sh",
                hints={"markup": "pango"},
                on_leftclick="zsh -i -c 'vpnrh'",
                on_rightclick="zsh -i -c 'novpn'")
status.run()
