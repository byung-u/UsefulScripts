#!/bin/bash
# http://stackoverflow.com/questions/24628076/bash-convert-n-delimited-strings-into-array
# Result string delimetered newline like this.
#   _A_\n_B_\n_C_\n ... 

NOT_CHECK_DEFS="#|T2|MSG_COMP|_BUG_FIX_|_MLEAK_GARBAGE_|_TPS_|_MLEAK_|_DUPLICATE_"

DEFS=`cat Makefile | grep MDEFS | grep -Ev $NOT_CHECK_DEFS | cut -d ':' -f 3 | sed 's/MDEFS+=-D//g'`

# This is how to convert string to array like below.
SAVEIFS=$IFS
IFS=$'\n'
DEFS=($DEFS)
IFS=$SAVEIFS
for (( i=0; i<${#DEFS[@]}; i++ ))
do
    CMD="grep ${DEFS[$i]} *.[ch]"
    echo "--------------- ${DEFS[$i]} ---------------"
    $CMD
done
exit 0
