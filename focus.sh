# Get current focused window
current=$(pfw)

# Check if param was set
if [[ "$1" == "--bottom" ]]; then
	bottom=1
else
	bottom=0
fi

# Get mouse position
wmp=$(wmp)
mx=$(echo $wmp | cut -d " " -f 1)
my=$(echo $wmp | cut -d " " -f 2)

# Set default value for focus
focus="null"
for wid in $(lsw); do
	# Get x and y 
	wx1=$(wattr x $wid)
	wy1=$(wattr y $wid)
	# Check if mouse is above x and y position, and if it is keep checking
	if [ "$wx1" -le "$mx" ] && [ "$wy1" -le "$my" ]; then
		ww=$(wattr w $wid)
		wh=$(wattr h $wid)
		wx2=$((wx1 + ww)) 
		wy2=$((wy1 + wh))
		# Check if mouse is below x + w and y + h position, and if it is set it to focus
		if [ "$mx" -le "$wx2" ] && [ "$my" -le "$wy2" ]; then
			focus=$wid
			# if bottom is set end 
			# otherwise keep the loop going to see if windows higher in the stack have priority
			if [[ "$bottom" -eq 1 ]]; then
				break
			fi
		fi
	fi
done

# If a value was set for focus then focus it
if [ $focus != "null" ]; then
	if [[ "$focus" != "$current" ]]; then
		# Give the window focus
		chwso -r $focus &
		wtf $focus &
		colourBorder.sh -f $focus
	fi
# If no focus was set, than focus the root window
else 
	wtf $(lsw -r) &
fi


# Recolour current border
if [[ "$focus" != "$current" ]]; then
	colourBorder.sh -d $current
fi
