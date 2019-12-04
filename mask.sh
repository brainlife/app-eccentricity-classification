#!/bin/bash

eccentricity=`jq -r '.eccentricity' config.json`
minDegree=(`jq -r '.MinDegree' config.json`)
maxDegree=(`jq -r '.MaxDegree' config.json`)
roi1=`jq -r '.seed_roi' config.json`

if [[ ${roi1} == '008109' ]]; then
	# make left hemisphere eccentricity
	fslmaths eccentricity.nii.gz -mul lh.ribbon.nii.gz eccentricity_left.nii.gz
	for DEG in ${!minDegree[@]}
	do
		fslmaths eccentricity_left.nii.gz -thr ${minDegree[$DEG]} -uthr ${maxDegree[$DEG]} -bin Ecc${minDegree[$DEG]}to${maxDegree[$DEG]}.nii.gz
	done
else
	# make right hemisphere eccentricity
	fslmaths eccentricity.nii.gz -mul rh.ribbon.nii.gz eccentricity_right.nii.gz
	for DEG in ${!minDegree[@]}
	do
		fslmaths eccentricity_right.nii.gz -thr ${minDegree[$DEG]} -uthr ${maxDegree[$DEG]} -bin Ecc${minDegree[$DEG]}to${maxDegree[$DEG]}.nii.gz
	done
fi

