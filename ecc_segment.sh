#!/bin/bash

# top variables
track=`jq -r '.track' config.json`
indices=`jq -r '.selectIndices' config.json`

# if user doesn't input selected tract indices, make indices variable to all indices found in assignments.txt
if [ -z ${indices} ]; then
	holder=(*track*.tck)
	indices=""
	for (( i=0; i<${#holder[*]}; i++ ));
	do
		indices="$indices $((i+1))"
	done
fi

# loop through all indices to segment by eccentricity
for i in ${indices}
do
	connectome2tck track${i}.tck track${i}_assignments_both_endpoints.txt track${i}_parc -file per_node
done

[ ! -d tmp ] && mkdir tmp 
mv track*_parc*.tck ./tmp/
mv names.txt ./tmp/

mv *.tck *.txt *.nii.gz ./raw/

mv ./tmp/* ./ && rm -rf tmp

# create new tractogram
if [ ! -f track/track.tck ]; then
	tckedit ${holder[*]} track/track.tck
	tckinfo ./track/track.tck >> track/track_info.txt
fi