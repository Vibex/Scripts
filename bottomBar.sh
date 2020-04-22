# !/bin/bash
fbc=$(colour -a)
fbcu=$(colour -b -a)
kbc=$(colour -r)
kbcu=$(colour -b -r)

# Get the current sub window to use for sizing
fn_sub() {
	if [[ -n $(cat "$WMPATH/wm/tiled") && $(wc -l "$WMPATH/wm/tiled" | cut -d " " -f 1) -eq 1 ]]; then
		local out="multi"
	else
		local out=$(tail -1 "$WMPATH/wm/tiled")
		if [[ -z "$out" ]]; then
			out="multi"
		fi
	fi
	echo "$out"
}

# Get the width of a window
# Returns root window width if window doesn't exist (particularly when receiving 'multi' from fn_sub)
# Arguments: string
fn_size() {
	if wattr $1; then
		wattr w $1
	else
		wattr w $(lsw -r)
	fi
}

# Create the name toggle button
# Arguments: wid
fn_nameButton() {
	if [[ -e "$WMPATH/wm/bar1_ids" ]]; then
		panda.sh -w 10 -A "$1" "rm $WMPATH/wm/bar1_ids"
	else
		panda.sh -w 10 -A "$(wname $1 || echo "null")" "touch $WMPATH/wm/bar1_ids"
	fi
}

# Create a button
# Arguments: 
fn_buttonOne() {
	panda.sh -o + -w 10 -B "$fbc" -L "$fbcu" -A "_" "echo a" -o - -R -P
}

# Create a button
# Arguments: 
fn_buttonTwo() {
	panda.sh -o + -w 10 -B "$fbc" -L "$fbcu" -A "+" "echo a" -o - -R -P
}

# Create the tile/untile button
# Arguments: wid
fn_tileButton() {
	if [[ "$(cat "$WMPATH/wm/tiled")" == *"$1"* ]]; then
		panda.sh -B "$fbc" -L "$fbcu" -w 10 -o + -A "U" "tile.sh -u $1" -o - -R -P
	else
		panda.sh -B "$fbc" -L "$fbcu" -w 10 -o + -A "T" "tile.sh -s $1" -o - -R -P
	fi
}

# Create the kill button
# Arguments: wid
fn_killButton() {
	panda.sh -w 10 -B "$kbc" -L "$kbcu" -o + -A "X" "killw $1" -o - 
}

fn_update() {
	local old0=$(fn_sub)
	local old1=$(fn_size $old0)
	local current0=$old0
	local current1=$old1
	
	local fw=""
	
	local nameb=""
	local button1=""
	local button2=""
	local tileb=""
	local killb=""
	while [[ -e "$WMPATH/wm/bar1" && "$old0" == "$current0" && "$old1" == "$current1" ]]; do
		fw=$(pfw || $(lsw -r))
		nameb="$(fn_nameButton $fw)"
		button1="$(fn_buttonOne)"
		button2="$(fn_buttonTwo)"
		tileb="$(fn_tileButton $fw)"
		killb="$(fn_killButton $fw)"

		panda.sh -l "$nameb" -r -D "$button1" -P -D "$button2" -P -D "$tileb" -P -D "$killb"
		sleep .1;
		old0=$(fn_sub)
		old1=$(fn_size $old0)
	done
}

fn_geometry() {
	local wid=$(fn_sub)
	local max=$(wattr w $(lsw -r))
	if [[ "$wid" == "multi" ]]; then
		local width=$max
		local x=0
	else
		local border=$(cat "$WMPATH/wm/border")
		local width=$(wattr w $wid)
		local cx=$(wattr x $wid)
		width=$(( $width + $border + $border ))
		cx=$(( $cx + ($width / 2) ))
		if [[ "$cx" -gt $(( $max / 2 )) ]]; then
			local x=$(wattr x $wid)
		else
			local x=$(wattr x $wid)
			x=$(( $x - $gap ))
		fi
	fi
	echo "-g $(echo $width)x$(cat "$WMPATH/wm/barh")+$x+0"
}

while [[ -e "$WMPATH/wm/bar1" ]]; do
	geometry=$(fn_geometry)
	fn_update | lemonbar -b $geometry $(cat "$WMPATH/wm/bar_args") | bash
done
