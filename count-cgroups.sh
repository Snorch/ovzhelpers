#!/bin/bash
if [ "$#" -ne 2 ]; then
	echo "usage: $0 <VEID> <outfile>"
	exit 1
fi
VEID=$1
OUTFILE=$2

CONTROLLERS=$(find /sys/fs/cgroup/ -maxdepth 1 -mindepth 1 -type d)

for controller in $CONTROLLERS; do
	COUNT=$(find $controller -type d -regex "$controller\(\|/machine.slice\)/$VEID/.*" | tee -a $OUTFILE | wc -l)
	echo "$controller $COUNT" >> $OUTFILE
done
