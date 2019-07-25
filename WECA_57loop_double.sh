#!/bin/bash
echo "######################################"
echo "Wolfram's elementary cellular automata"
echo "######################################"
echo "--------- 57 loop madness ------------"
RULE_dec=57
echo "RULE: $RULE_dec"
#convert decimal rule number to binary (e.g. Rule30 -> 00011110)
RULE_bin=$(echo "obase=2;$RULE_dec" | bc)
# bring up to 8 digits
while [ ${#RULE_bin} -lt 8 ]
do
	RULE_bin="0"$RULE_bin
done

echo "Binary rule: "$RULE_bin

read -a RULE_array <<< $(echo $RULE_bin | sed 's/./& /g')

#convert 0s to spaces and 1s to 0s for displaying
declare -a RULE_array_converted
for x in ${!RULE_array[@]}
do
	if [ ${RULE_array[$x]} == 0 ]; then RULE_array_converted[$x]=" "; else RULE_array_converted[$x]="0"; fi
done

WIDTH=$1 #width of rows including 0 pos
NUM_ROWS=$(( 1 + ( $WIDTH - 2 ) + ( $WIDTH - 2 ) / 2 ))


declare -a WECA_array_A
#initial array with center 1
for x in $(seq 0 `expr $WIDTH + 1`) #151 is equal to pos 1
do
	if [ $x == `expr $WIDTH / 2` ]
	then
		WECA_array_A[$x]="0"
	else
		WECA_array_A[$x]=" "
	fi
done

declare -a WECA_array_start
WECA_array_start=("${WECA_array_A[@]}")

declare -A WECA_key

WECA_key["000"]=${RULE_array_converted[0]}
WECA_key["00 "]=${RULE_array_converted[1]}
WECA_key["0 0"]=${RULE_array_converted[2]}
WECA_key["0  "]=${RULE_array_converted[3]}
WECA_key[" 00"]=${RULE_array_converted[4]}
WECA_key[" 0 "]=${RULE_array_converted[5]}
WECA_key["  0"]=${RULE_array_converted[6]}
WECA_key["   "]=${RULE_array_converted[7]}

ruleprint_top=$(printf "%s|\t|" "${!WECA_key[@]}")
ruleprint_bottom=$(printf "%s| \t |" "${WECA_key[@]}")
echo "|$ruleprint_top"
echo " |$ruleprint_bottom"

declare -a WECA_array_B

#main loop
while [ TRUE ]
do
	tempcounter=1
	WECA_array_A=("${WECA_array_start[@]}")
	while [ $tempcounter -le $NUM_ROWS ]
	do
		output=$(printf "%s" "${WECA_array_A[@]}")
		#display row
		echo ":${output:1:$WIDTH}${output:1:$WIDTH}:"

		#calculate next line
		for x in $(seq 1 $WIDTH)
		do
			KEY="${output:`expr $x - 1`:3}"
			WECA_array_B[$x]="${WECA_key[$KEY]}"
		done
		#set last element equal to [1] and first element equal to [$WIDTH]
		WECA_array_B[`expr $WIDTH + 1`]=${WECA_array_B[1]}
		WECA_array_B[0]=${WECA_array_B[$WIDTH]}
		#set A equal to B
		WECA_array_A=("${WECA_array_B[@]}")

		tempcounter=$(( $tempcounter + 1 ))
	done
done
