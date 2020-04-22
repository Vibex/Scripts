# Tiling Settings
pattern="3/5 rstack"
gap=16

# Border Settings
border=4
active_border_col="$(colour -u)"
inactive_border_col="$(colour -b -a)"

# Bar Settings
barh=40
bar_args="-d -u "$(( $border / 2 ))" -f LucidaG:size=12 -B $(colour -o background: 2) -F $(colour -o foreground: 2)"

# Dmenu Settings
dmenu_args="-h $barh -fn LucidaG:size=12 -nb $(colour -o background: 2) -nf $(colour -o foreground: 2) -sb $(colour -m) -sf $(colour -o foreground: 2)"

# Check args
notiled=0
notags=0
killbar=0
while :
do
	case $1 in
		"--all") notiled=1; notags=1; killbar=1; break;;
		"--no-tiled") notiled=1; shift 1;; # Don't reset tiling (for when calling init.sh during an active session)
		"--no-tags") notags=1; shift 1;; # Don't reset tags (for when calling init.sh during an active session)
		"--kill-bar") killbar=1; shift 1;; # Kill all active bars (for when calling init.sh during an active session)
		*)break;;
	esac
done

# Calculations
x0=$(wattr x $(lsw -r))
y0=$(wattr y $(lsw -r))
x1=$(wattr w $(lsw -r))
y1=$(wattr h $(lsw -r))
x1=$(( $x0 + $x1 - $gap ))
y1=$(( $y0 + $y1 - $gap ))
x0=$(( $x0 + $gap ))
y0=$(( $y0 + $gap + $barh ))

# Make sure directory exists
mkdir -p "$WMPATH/wm"

# Set geometry
echo $x0 > "$WMPATH/wm/x0"
echo $y0 > "$WMPATH/wm/y0"
echo $x1 > "$WMPATH/wm/x1"
echo $y1 > "$WMPATH/wm/y1"
echo $gap > "$WMPATH/wm/gap"

# Set tiling
if [[ $notiled -eq 0 ]]; then
	echo $pattern > "$WMPATH/wm/pattern"
	echo "" > "$WMPATH/wm/tiled"
	echo "0" > "$WMPATH/wm/tiled_count"
fi

# Set tags
if [[ $notags -eq 0 ]]; then
	echo "1" > "$WMPATH/wm/tags"
fi

# Set borders
echo $border > "$WMPATH/wm/border"
echo $inactive_border_col > "$WMPATH/wm/border_colour0"
echo $active_border_col > "$WMPATH/wm/border_colour1"

# Set dmenu settings
echo $dmenu_args > "$WMPATH/wm/dmenu_args"

# Set bar settings
echo $barh > "$WMPATH/wm/barh"
echo $bar_args > "$WMPATH/wm/bar_args"
if [[ $killbar -eq 1 ]]; then
	rm "$WMPATH/wm/bar0"
	rm "$WMPATH/wm/bar1"
	sleep 1.5;
fi
touch "$WMPATH/wm/bar0"
touch "$WMPATH/wm/bar1"

# Launch bars
pkill lemonbar # Only needed for rerunning init.sh after startup
bash "$HOME/Documents/Git/Scripts/topBar.sh" &
bash "$HOME/Documents/Git/Scripts/bottomBar.sh" &
