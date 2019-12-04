#!/bin/bash

input_nii_gz=$(jq -r .dwi config.json)
dtiinit=`jq -r '.dtiinit' config.json`
freesurfer=`jq -r '.freesurfer' config.json`
eccentricity=`jq -r '.eccentricity' config.json`
hemi="lh rh"

if [[ ! ${dtiinit} == "null" ]]; then
        export input_nii_gz=$dtiinit/`jq -r '.files.alignedDwRaw' $dtiinit/dt6.json`
fi

for HEMI in $hemi
do
	mri_vol2vol --mov ${freesurfer}/mri/${HEMI}.ribbon.mgz --targ ${input_nii_gz} --regheader --o ${HEMI}.ribbon.nii.gz
done

mri_vol2vol --mov ${eccentricity} --targ ${input_nii_gz} --regheader --o eccentricity.nii.gz
