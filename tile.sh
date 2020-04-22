fn_add() {
	echo "$1" >> "$WMPATH/wm/tiled"
	tag.sh -s $1 "$(cat "$WMPATH/wm/tags" | head -n 1)"
}

fn_remove() {
	sed -i "/$1/d" "$WMPATH/wm/tiled"
}

mode=0
case $1 in
	"-s") mode=0
		shift 1;;
	"-u") mode=1
		shift 1;;
	"-t") mode=2
		shift 1;;
	"-r") mode=3
		shift 1;;
esac
	


if [[ "$mode" != "3" ]]; then
	if [[ "$(lsw -r)" != "$1" ]]; then
		if wattr $1; then
			if [[ "$mode" -eq 0 ]] && [[ "$(cat "$WMPATH/wm/tiled")" != *"$1"* ]]; then
				fn_add $1
			elif [[ "$mode" -eq 1 ]]; then
				fn_remove $1
			elif [[ "$mode" -eq 2 ]]; then
				if [[ "$(cat "$WMPATH/wm/tiled")" == *"$1"* ]]; then
					fn_remove $1
				else
					fn_add $1
				fi
			fi
		fi
	fi
fi

x0=$(cat "$WMPATH/wm/x0")
y0=$(cat "$WMPATH/wm/y0")
x1=$(cat "$WMPATH/wm/x1")
y1=$(cat "$WMPATH/wm/y1")
gap=$(cat "$WMPATH/wm/gap")
pattern=$(cat "$WMPATH/wm/pattern")

sed -i '/^[[:space:]]*$/d' "$WMPATH/wm/tiled" # Remove blank lines from file
wids=""
count=0
for w in $(cat "$WMPATH/wm/tiled"); do
	if wattr $w; then
		if [[ $(bash /home/vibex/Documents/Git/Scripts/tag.sh -c $w) -ne 0 ]]; then
			wids="$wids $w"
			count=$(( $count + 1 ))
		fi
	else
		sed -i "/$w/d" "$WMPATH/wm/tiled"
	fi
done
echo $count > "$WMPATH/wm/tiled_count"
if [[ $count -ge 1 ]]; then
	if [[ -e "$WMPATH/wm/bar1" ]]; then
		ending=":0,0,0,-$(cat "$WMPATH/wm/barh")"
	else
		ending=""
	fi
	placemaker.sh --geometry "$x0" "$y0" "$x1" "$y1" --gap "$gap" -T $pattern $wids$ending
fi
