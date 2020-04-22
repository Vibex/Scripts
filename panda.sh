# !/bin/bash
PADDING=""

output=""
while :
do
	case $1 in
		### lemonbar Options
		# Positioning Options
		"--left" | "-l" ) output="$output%{l}"; shift 1;; 
		"--center" | "-c" ) output="$output%{c}"; shift 1;; 
		"--right" | "-r" ) output="$output%{r}"; shift 1;; 
		"--offset" | "-O" ) output="$output%{O$2}"; shift 2;; 
		# Color Options
		"--color" | "--colour" | "-C" ) output="$output%{B$2}%{F$3}%{U$4}"; shift 4;;
		"--background" | "-B" ) output="$output%{B$2}"; shift 2;; 
		"--foreground" | "-F" ) output="$output%{F$2}"; shift 2;; 
		"--line" | "-L" ) output="$output%{U$2}"; shift 2;; 
		"--invert" | "-I" ) output="$output%{R}"; shift 1;; 
		"--reset" | "-R" ) output="$output%{B-}%{F-}%{U-}"; shift 1;; 
		# Monitor Options
		"--monitor" | "-M" ) output="$output%{S$2}"; shift 2;; 
		# Font Options
		"--index" | "-i" ) output="$output%{T$2}"; shift 2;; 
		# Attribute Options
		"--underline" | "-u" ) output="$output%{$2u}"; shift 2;; 
		"--overline" | "-o" ) output="$output%{$2o}"; shift 2;; 
		# Actions
		"--action" | "-A" ) output="$output%{A:$3:}$PADDING$2$PADDING%{A}"; shift 3;;
		"--start-action" | "-S" ) output="$output%{A:$2:}"; shift 2;;
		"--end-action" | "-E" ) output="$output%{A}"; shift 2;;

		### PanDA Options
		"--nopad" | "-N" ) output="$output$2"; shift 2;; 
		"--delayed-reset" | "-D" ) output="$output$PADDING$2$PADDING%{B-}%{F-}%{U-}"; shift 2;; 
		"--pad" | "-P" ) output="$output$PADDING"; shift 1;; 
		"--padding" | "-p" ) PADDING="$2"; shift 2;; 
		"--padding-width" | "-w" ) PADDING="%{O$2}"; shift 2;; 
		"--toggle" | "-T" ) 
			if [[ "$1" -eq 0 ]]; then
				temp="$2"
			else
				temp="$3"
			fi
			output="$output$PADDING$temp$PADDING"
			shift 3;;

		### Input
		*) if [[ "$#" -le 0 ]]; then
				break
			else
				output="$(echo "$output")$PADDING$1$PADDING"
				shift 1;
			fi;;
	esac
done

echo "$output"
