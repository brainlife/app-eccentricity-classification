#!/bin/bash

# top variables
track=`jq -r '.track' config.json`
parc=`jq -r '.parcellations' config.json`

[ ! -f parc.nii.gz ] && cp ${parc} ./parc.nii.gz

# generate individual tracts for each index
tck2connectome ${track} parc.nii.gz -out_assignments track_assignments.txt tmp.csv -force
connectome2tck ${track}  track_assignments.txt track -file per_node

if [ ! -f track/track.tck ]; then
	holder=(*track*.tck)
	tckedit ${holder[*]} track/track.tck
	tckinfo ./track/track.tck >> track/track_info.txt
fi