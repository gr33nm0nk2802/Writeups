#!/bin/bash
cd test/

f='pop.zip'

while [ 1 ] 
do

	file $f | grep 'ASCII' > /dev/null
	if [ "$?" -eq "1" ]; then
		7z x $f > /dev/null
		rm $f
		f=$(ls)
	else 
		cat $f
		break
 	fi
done
