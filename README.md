[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.232-blue.svg)](https://doi.org/https://doi.org/10.25663/brainlife.app.232)

# Bundle segmented tracks by eccentricity

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Segments a whole-brain tractogram into streamlines that connect a parcellation's labels with MRtrix3 tck2connectome and connectome2tck, and outputs the merged tractogram.**

Assigns every streamline to the parcels at its two endpoints with tck2connectome, extracts streamlines per parcel with connectome2tck and concatenates them into one .tck. With both_endpoints set, only streamlines whose two endpoints fall in the same parcel are kept. The parcellation must be in the same space as the tractogram.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.763](https://doi.org/10.25663/brainlife.app.763)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `track` | `neuro/track/tck` | yes | Whole-brain tractogram (.tck). |
| `parcellation` | `neuro/parcellation/volume` | yes | Volumetric parcellation whose labels define the segmentation. Must be in the same space as the tractogram. |

| Output | Datatype | Description |
|---|---|---|
| `track` | `neuro/track/tck` | Tractogram (.tck) of the streamlines assigned to the parcellation's labels. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `both_endpoints` | boolean | `false` | If true, keep only streamlines whose two endpoints fall in the same parcel. |

Runtime: container `brainlife/mrtrix3:3.0.0`; 1 CPUs; 1.5 h walltime.

<!-- brainlife-app:end -->

This app will This app will bundle tracks by population receptive field (prf) derived eccentricity metrics in the form of ROIs. An example use case for this app would be bundling the optic radiation by specific eccentricity values.

### Authors

- Brad Caron (bacaron@utexas.edu)

### Contributors

- Soichi Hayashi (shayashi@iu.edu)

### Funding Acknowledgement

brainlife.io is publicly funded and for the sustainability of the project it is helpful to Acknowledge the use of the platform. We kindly ask that you acknowledge the funding below in your publications and code reusing this code.

[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citations

We kindly ask that you cite the following articles when publishing papers and code using this code.

1. Avesani, P., McPherson, B., Hayashi, S. et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). https://doi.org/10.1038/s41597-019-0073-y

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University

## Running the App

### On Brainlife.io

You can submit this App online at [https://doi.org/https://doi.org/10.25663/brainlife.app.232](https://doi.org/https://doi.org/10.25663/brainlife.app.232) via the 'Execute' tab.

### Running Locally (on your machine)

1. git clone this repo

2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
	"classification": "/input/wmc/classification.mat",
	"tracts": "/input/wmc/tracts",
	"surfaces": "/input/wmc/surfaces",
	"wbFG": "/input/track/track.tck",
	"rois": "/input/rois/rois",
	"tractNames": "leftMeyers",
	"visualArea": "varea",
	"MinDegree": "0 15 30",
	"MaxDegree": "3 30 90",
	"operations": "and and and"
}
```

### Sample Datasets

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli). 

```
npm install -g brainlife
bl login
mkdir input
bl dataset download
```

3. Launch the App by executing 'main'

```bash
./main
```

## Output

The main output of this App is a wmc datatype containing the streamline information for each of the newly bundled tracts

#### Product.json

The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing.

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you will need to install following dependencies.   

- matlab: https://www.mathworks.com/products/matlab.html
- jsonlab: https://github.com/fangq/jsonlab
- vistasoft: https://github.com/vistalab/vistasoft
- wma_tools: https://github.com/DanNBullock/wma_tools

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University
