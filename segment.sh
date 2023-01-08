#!/bin/bash

# top variables
track=`jq -r '.track' config.json`
indices=`jq -r '.selectIndices' config.json`
tractNames=(`cat names.txt`)

# generate individual tracts for each index
connectome2tck ${track} assignments.txt node -files per_node


# if user doesn't input selected tract indices, make indices variable to all indices found in assignments.txt
if [ -z ${indices} ]; then
	holder=(*node*.tck)
	indices=""
	for (( i=0; i<${#holder[*]}; i++ )); then
		indices="$indices $((i+1))"
	done
fi

# loop through all indices to combine
for i in ${indices}
do
	tck2connectome node${i}.tck parc.nii.gz -out_assignments node${i}_assignments.txt tmp.csv -force
done