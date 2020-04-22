#!/bin/bash

COL="FFFFFF"

fn_focused() {
	 COL="$(cat "$WMPATH/wm/border_colour1" | cut -d "#" -f 2)"
}

fn_unfocused() {
	 COL="$(cat "$WMPATH/wm/border_colour0" | cut -d "#" -f 2)"
}

fn_detect() {
	if [[ "$(pfw)" == "$w" ]]; then
		fn_focused
	else
		fn_unfocused
	fi
}

fn_setBorder() {
	chwb -s "$(cat "$WMPATH/wm/border")" -c "$COL" $1
}

fn_loopSetBorder() {
	for w in $(lsw); do
		fn_detect $w
		fn_setBorder $w
	done
}

case $1 in
	"-f" | "--focused" ) fn_focused; fn_setBorder $2;;
	"-u" | "--unfocused" ) fn_unfocused; fn_setBorder $2;;
	"-d" | "--detect" ) fn_detect $2; fn_setBorder $2;;
	"-a" | "--all" ) fn_loopSetBorder;;
esac
