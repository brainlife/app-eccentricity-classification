#!/bin/bash

# top variables
track=`jq -r '.track' config.json`
indices=`jq -r '.selectIndices' config.json`
parc=`jq -r '.parcellations' config.json`

[ ! -f parc.nii.gz ] && cp ${parc} ./parc.nii.gz

# generate individual tracts for each index
connectome2tck ${track} assignments.txt track -files per_node

# if user doesn't input selected tract indices, make indices variable to all indices found in assignments.txt
if [ -z ${indices} ]; then
	holder=(*track*.tck)
	indices=""
	for (( i=0; i<${#holder[*]}; i++ ));
	do
		indices="$indices $((i+1))"
	done
fi

# loop through all indices to combine
for i in ${indices}
do
	tck2connectome track${i}.tck parc.nii.gz -out_assignments track${i}_assignments.txt tmp.csv -force
done