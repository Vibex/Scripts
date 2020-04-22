mbg="$(colour -g)"
mbgu="$(colour -b -g)"

tbg="$(colour -a)"
tbgu="$(colour -b -a)"

cbg="$tbg"
cbgu="$tbgu"

bbg="$cbg"
bbgu="$cbgu"
bbgc="$(colour -g)"
bbgcu="$(colour -b -g)"
bbgl="$(colour -r)"
bbglu="$(colour -b -r)"

menumid="-u - -P -u + -B $mbg -L $mbgu -D"
fn_menu() {
	panda.sh -w 10 -u + -B $mbg -L $mbgu -D "A" $menumid "B" $menumid "C" -u -
}

tagmid="-u - -P -u + -B $tbg -L $tbgu"
check_tags="1 2 3 4"
colA="-"
colB="$(colour -b -a)"
fn_tags() {
	local build=""
	local col=""
	for i in $check_tags; do
		if [[ "$(cat "$WMPATH/wm/tags")" == *"$i"* ]]; then
			col="$colA"
		else
			col="$colB"
		fi
		build="$build$(panda.sh -w 10 $tagmid -F $col -A $i "tagTile.sh -t $i" -R)"
	done

	echo "$build$(panda.sh -u -)"
}

fn_tile() {
	panda.sh -w 10 -P "$(cat "$WMPATH/wm/pattern")"
}

fn_clock() {
	DATETIME=$(date "+%a %b %d, %H:%M");
	panda.sh -w 10 -u + -L $cbgu -B $cbg -P "$DATETIME" -P -u -
}

fn_battery() {
	BAT=$(acpi --battery | head -n 1);
	BATPERC=$(echo "$BAT" | cut -d , -f 2 | tr -d "%");
	BATSTATE=$(echo "$BAT" | cut -d : -f 2 | cut -d , -f 1);
	local COL0="$bbg"
	local COL1="$bbgu"
	if [[ "$BATPERC" -lt 40 ]]; then
		COL0="$bbgl"
		COL1="$bbglu"
	fi
	if [[ "$BATSTATE" == *"Charging"* ]]; then
		COL0="$bbgc"
		COL1="$bbgcu"
	fi

	panda.sh -w 10 -u + -L $COL1 -B $COL0 "$BATPERC%" -u -
}

fn_update() {
	while [[ -e "$WMPATH/wm/bar0" ]]; do
		panda.sh -l "$(fn_menu)" -R "$(fn_tags)" -R "$(fn_tile)" -c "$(fn_clock)" -R -r "$(fn_battery)" -R
		sleep .05;
	done
}
fn_update | lemonbar -g "1920x$(cat "$WMPATH/wm/barh")+0+0" $(cat "$WMPATH/wm/bar_args") | bash
