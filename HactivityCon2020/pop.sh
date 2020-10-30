#!/bin/bash
# Hacktivitycon recursive zip writeup
cd test/

# specify the file
f='pop.zip'

# Infinite loop
while [ 1 ] 
do
	# check the filetype
	file $f | grep 'ASCII' > /dev/null
	if [ "$?" -eq "1" ]; then
		# Extract files reverting the errors
		7z x $f > /dev/null
		rm $f
		f=$(ls)
	else 
		cat $f
		break
 	fi
done
