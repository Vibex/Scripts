# !/bin/bash

# Tags file
TFILE="$WMPATH/wm/tags"

# Remap
# 0 = No
# 1 = Yes
REMAP=1

# Check to see if a window is in the tags list
# Arguments: wid
fn_tagCheckWid() {
	fn_tagCheckTag $(atomx MKWM_TAG $1)
}

# Check to see if a tag is in the tags list
# Returns:
# -1 = no tag set
#  0 = not on tag
#  1 = on tag
# Arguments: tag
fn_tagCheckTag() {
	if [[ -z "$1" ]]; then
		echo "-1"
	elif [[ "$(cat "$TFILE")" == *"$1"* ]]; then
		echo "1"
	else 
		echo "0"
	fi
	
}

# Toggle a tags state
# Argument: tag
fn_tagToggle() {
	sed -i '/^[[:space:]]*$/d' "$TFILE"
	if [[ "$(fn_tagCheckTag $1)" -eq 1 ]]; then
		sed -i "/$1/d" "$TFILE"
	else
		echo $1 >> "$TFILE"
	fi
}

fn_list() {
	echo "Tag File:"
	echo "$(cat $TFILE)"
	echo ""
	echo "Windows:"
	for w in $(lsw -a); do
		echo "id: $w"
		echo "tag: $(atomx MKWM_TAG $w)"
		echo ""
	done
}

if [[ "$1" == "--no-remap" ]]; then
	REMAP=0
	shift 1
fi

case $1 in
	"-l" | "--list") 		fn_list;REMAP=0;;			# List all the tags in the tag file
	"-c" | "--check") 		fn_tagCheckWid $2;REMAP=0;;	# Check if a window is on an active tag
	"-C" | "--check-alt") 	fn_tagCheckTag $2;REMAP=0;;	# Check if a tag is active
	"-s" | "--set") 		t=$(atomx MKWM_TAG=$3 $2);;	# Set the tag for a window
	"-u" | "--unset") 		t=$(atomx -d MKWM_TAG $2);;	# Set the tag for a window
	"-t" | "--toggle") 		fn_tagToggle $2;;			# Toggle a tags state
	"-f" | "--force") 		echo $2 > $TFILE;;			# Remove all other tags and set this one
esac

if [[ $REMAP -eq 1 ]]; then
	for w in $(lsw -a); do
		check=$(fn_tagCheckWid $w)
		if [[ $check -eq 1 ]]; then
			mapw -m $w
		elif [[ $check -eq 0 ]]; then
			mapw -u $w
		fi
	done
fi
