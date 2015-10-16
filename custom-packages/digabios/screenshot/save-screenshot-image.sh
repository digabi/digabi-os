#!/bin/sh
mv "$1" /tmp/latest_screenshot.png
notify-send -t 5000 -i digabi-screenshot "Kuvankaappaus otettu" "Palaa sähköiseen kokeeseen ja klikkaa\n'Liitä tekemäsi kuvankaappaus' -painiketta."
