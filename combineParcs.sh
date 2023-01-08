#!/bin/bash

# top variables
parcs=($(jq -r '.parcellations' config.json  | tr -d '[]," '))

# count number of input parcellations. if only 1 is inputted, just binarize the parcellation. if not, loop through all parcellations
if [[ ${#parcs[*]} == 1 ]]; then
  fslmaths $parcs -bin parc.nii.gz
else
  # set up counter variable
  ctr=1

  # loop through all parcellations
  for i in ${parcs[*]}
  do
  	# binarize and multiply by counter value
    fslmaths ${i} -bin -mul ${ctr} parc${ctr}.nii.gz

    # if it's first parcellation, set up fslmaths call so we can add all parcellations together. if not, use -add flag
    if [[ ${ctr} -eq 1 ]]; then
    	cmd="fslmaths parc${ctr}.nii.gz"
    else
    	cmd="$cmd -add parc${ctr}.nii.gz"
    fi

    # update counter
    ctr=$((ctr+1))
  done
fi

# add parcellations together
$cmd parc.nii.gz

# [ ! -f parc.nii.gz ] && echo "something went wrong. check logs and derivatives" && exit 1