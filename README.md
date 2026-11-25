<h1 align="center">Segment tracts by eccentricity and parcellation</h1>

<p align="center">
  Sub-bundles of white matter tracts, or of a whole-brain tractogram, defined by the parcels (for example pRF eccentricity bins) that their streamline endpoints reach.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.763"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.763-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> **This branch, `mrtrix3-wbfg-v1.0`, runs 2 brainlife.io Apps** that share the same code:
>
> - Segment whole-brain tractogram -  Parcellation ([doi:10.25663/brainlife.app.763](https://doi.org/10.25663/brainlife.app.763))
> - Segment whole-brain tractogram by Eccentricity - Parcellation ([doi:10.25663/brainlife.app.760](https://doi.org/10.25663/brainlife.app.760))
>
> The other Apps in this repository are listed under **Versions on brainlife.io** below.

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

### Segment whole-brain tractogram -  Parcellation

> **Segments a whole-brain tractogram into streamlines that connect a parcellation's labels with MRtrix3 tck2connectome and connectome2tck, and outputs the merged tractogram.**

Assigns every streamline to the parcels at its two endpoints with tck2connectome, extracts streamlines per parcel with connectome2tck and concatenates them into one .tck. With both_endpoints set, only streamlines whose two endpoints fall in the same parcel are kept. The parcellation must be in the same space as the tractogram.

| | |
|---|---|
| **Inputs** | `neuro/track/tck` · `neuro/parcellation/volume` |
| **Outputs** | `neuro/track/tck` |
| **Container** | `brainlife/mrtrix3:3.0.0` |
| **Resources** | 1 CPUs · 1.5 h walltime |
| **Run it** | [doi.org/10.25663/brainlife.app.763](https://doi.org/10.25663/brainlife.app.763) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `track` | `neuro/track/tck` | yes | Whole-brain tractogram (.tck). |
| `parcellation` | `neuro/parcellation/volume` | yes | Volumetric parcellation whose labels define the segmentation. Must be in the same space as the tractogram. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `track` | `neuro/track/tck` | Tractogram (.tck) of the streamlines assigned to the parcellation's labels. |

<details>
<summary><b>Parameters</b> (1)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `both_endpoints` | boolean | `false` | If true, keep only streamlines whose two endpoints fall in the same parcel. |

</details>

### Segment whole-brain tractogram by Eccentricity - Parcellation

> **Segments a whole-brain tractogram into streamlines that connect a parcellation's labels (eccentricity parcels) with MRtrix3 tck2connectome and connectome2tck, and outputs the merged tractogram.**

Assigns every streamline to the parcels at its two endpoints with tck2connectome, extracts streamlines per parcel with connectome2tck and concatenates them into one .tck. With both_endpoints set, only streamlines whose two endpoints fall in the same parcel are kept. The parcellation must be in the same space as the tractogram.

| | |
|---|---|
| **Inputs** | `neuro/track/tck` · `neuro/parcellation/volume` |
| **Outputs** | `neuro/track/tck` |
| **Container** | `brainlife/mrtrix3:3.0.0` |
| **Resources** | 1 CPUs · 1.5 h walltime |
| **Run it** | [doi.org/10.25663/brainlife.app.760](https://doi.org/10.25663/brainlife.app.760) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `track` | `neuro/track/tck` | yes | Whole-brain tractogram (.tck). |
| `parcellation` | `neuro/parcellation/volume` (eccentricity) | yes | Volumetric parcellation of eccentricity bins whose labels define the segmentation. Must be in the same space as the tractogram. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `track` | `neuro/track/tck` | Tractogram (.tck) of the streamlines assigned to the parcellation's labels. |

<details>
<summary><b>Parameters</b> (1)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `both_endpoints` | boolean | `false` | If true, keep only streamlines whose two endpoints fall in the same parcel. |

</details>

<!-- brainlife-app:end -->

## Versions on brainlife.io

Each version is a separate App on brainlife.io, built from a branch of this repository. The MATLAB Apps split tracts by eccentricity ROIs; the MRtrix3 Apps split tracts, or a whole-brain tractogram, by the labels of a volumetric parcellation.

| App | Tool | Branch | Run it | Status |
|---|---|---|---|---|
| **Segment whole-brain tractogram - Parcellation** (this branch) | MRtrix3 3.0.0 | [`mrtrix3-wbfg-v1.0`](https://github.com/brainlife/app-eccentricity-classification/tree/mrtrix3-wbfg-v1.0) | [doi:10.25663/brainlife.app.763](https://doi.org/10.25663/brainlife.app.763) | current |
| **Segment whole-brain tractogram by Eccentricity - Parcellation** (this branch) | MRtrix3 3.0.0 | [`mrtrix3-wbfg-v1.0`](https://github.com/brainlife/app-eccentricity-classification/tree/mrtrix3-wbfg-v1.0) | [doi:10.25663/brainlife.app.760](https://doi.org/10.25663/brainlife.app.760) | available |
| Bundle segmented tracks by eccentricity - Parcellation | MRtrix3 3.0.0, MATLAB R2017a | [`mrtrix3-v1.0`](https://github.com/brainlife/app-eccentricity-classification/tree/mrtrix3-v1.0) | [doi:10.25663/brainlife.app.714](https://doi.org/10.25663/brainlife.app.714) | available |
| Bundle segmented tracks by eccentricity - Parcellation (multiple parcellations) | MRtrix3 3.0.0, FSL 5.0.11, MATLAB R2017a | [`mrtrix3-v1.0-multipleparcs`](https://github.com/brainlife/app-eccentricity-classification/tree/mrtrix3-v1.0-multipleparcs) | [doi:10.25663/brainlife.app.712](https://doi.org/10.25663/brainlife.app.712) | available |
| Bundle segmented tracks by eccentricity | MATLAB R2017a | [`v1.0`](https://github.com/brainlife/app-eccentricity-classification/tree/v1.0) | [doi:10.25663/brainlife.app.648](https://doi.org/10.25663/brainlife.app.648) | available |
| Bundle segmented tracks by eccentricity - Parcellation (Matlab) | MATLAB R2017a | [`v1.0`](https://github.com/brainlife/app-eccentricity-classification/tree/v1.0) | [doi:10.25663/brainlife.app.649](https://doi.org/10.25663/brainlife.app.649) | deprecated |
| Bundle segmented tracks by eccentricity - Deprecated | MATLAB R2017a | [`v1.0`](https://github.com/brainlife/app-eccentricity-classification/tree/v1.0) | [doi:10.25663/brainlife.app.232](https://doi.org/10.25663/brainlife.app.232) | superseded by app.648 |

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.763](https://doi.org/10.25663/brainlife.app.763), choose a whole-brain tractogram (`neuro/track/tck`) and a volumetric parcellation (`neuro/parcellation/volume`) in the same space, decide whether to set `both_endpoints`, and press **Execute**. The output is a tractogram of the streamlines assigned to the parcellation's labels, archived to your project.

To split tracts that are already segmented (for example the optic radiation) rather than a whole-brain tractogram, use one of the "Bundle segmented tracks by eccentricity" Apps in the table above. They take a white matter classification (`neuro/wmc`) and its tractogram, and output a new classification with one tract per input tract and eccentricity bin.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). The containers (`brainlife/mrtrix3:3.0.0`, `brainlife/pyafq:1.0`) are pulled from Docker Hub on first use.

1. Clone this repository and check out the branch of the App you want (for example `git checkout mrtrix3-wbfg-v1.0`).
2. Create `config.json` with the paths to your inputs and the options you want:

   ```json
   {
       "track": "/input/track/track.tck",
       "parcellations": "/input/parcellation/parc.nii.gz",
       "key": "/input/parcellation/key.txt",
       "label": "/input/parcellation/label.json",
       "both_endpoints": false
   }
   ```

3. Run the App:

   ```bash
   ./main
   ```

The MATLAB version on the default branch (`master`, and `v1.0`) instead reads a white matter classification, a whole-brain tractogram and a directory of eccentricity ROIs:

```json
{
    "classification": "/input/wmc/classification.mat",
    "wbFG": "/input/track/track.tck",
    "rois": "/input/rois/rois/",
    "visualArea": "varea",
    "tractNames": "leftILF rightILF leftVOF rightVOF",
    "operations": "endpoints endpoints both_endpoints both_endpoints",
    "MinDegree": "0 6 30",
    "MaxDegree": "3 30 90"
}
```

It runs the compiled MATLAB code in `compiled/` with the `brainlife/mcr:neurodebian1604-r2017a` container. Running the MATLAB source instead of the compiled binary needs [MATLAB](https://www.mathworks.com/products/matlab.html), [jsonlab](https://github.com/fangq/jsonlab), [vistasoft](https://github.com/vistalab/vistasoft) and [wma_tools](https://github.com/DanNBullock/wma_tools).

### Sample data

Download sample datasets from brainlife.io with the [brainlife CLI](https://github.com/brainlife/cli):

```bash
npm install -g brainlife
bl login
mkdir input
bl dataset download <dataset id>
```

## Outputs

Whole-brain tractogram Apps (`mrtrix3-wbfg-v1.0`):

```text
track/
├── track.tck        streamlines assigned to the parcellation's labels
└── track_info.txt   tckinfo summary of track.tck
raw/                 intermediate assignments, per-parcel tractograms and the copied parcellation
```

Segmented-tract Apps (`mrtrix3-v1.0`, `mrtrix3-v1.0-multipleparcs`): `wmc/classification.mat` with one tract per selected input tract and parcel (named `<tract>_<parcel>`), its tract JSON files and fiber counts, and `track/track.tck` concatenating the sub-bundles.

MATLAB Apps (`master`, `v1.0`): `classification/classification.mat` with one tract per input tract and eccentricity bin (named `<tract>_Ecc<min>to<max>`), `classification/tracts/` for visualisation and `classification/output_fibercounts.txt`.

The App also writes `product.json`, which brainlife.io uses to display the results.

## Troubleshooting

- **`segmentation failed. see logs and derivatives`**: no streamlines were assigned to the parcellation. The parcellation must be in the same space as the tractogram; check the intermediate files in the working directory.
- **MATLAB versions fail to find ROIs**: the eccentricity ROIs must be named `ROI<visualArea>.Ecc<MinDegree>to<MaxDegree>.nii.gz` for every visual area and degree bin requested, as produced by the pRF-based ROI Apps on brainlife.io. `MinDegree`, `MaxDegree`, `tractNames` and `operations` are space-separated lists that must line up.

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Segment whole-brain tractogram -  Parcellation. brainlife.io App. [doi:10.25663/brainlife.app.763](https://doi.org/10.25663/brainlife.app.763)
- Segment whole-brain tractogram by Eccentricity - Parcellation. brainlife.io App. [doi:10.25663/brainlife.app.760](https://doi.org/10.25663/brainlife.app.760)
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Tournier et al. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. *NeuroImage* 202:116137 (2019). [doi:10.1016/j.neuroimage.2019.116137](https://doi.org/10.1016/j.neuroimage.2019.116137)
- Bullock et al. Associative white matter connecting the dorsal and ventral posterior human cortex. *Brain Structure and Function* 224:2631-2660 (2019). [doi:10.1007/s00429-019-01907-8](https://doi.org/10.1007/s00429-019-01907-8)
- Kruper et al. Evaluating the Reliability of Human Brain White Matter Tractometry. *Aperture Neuro* 2021 (2021). [doi:10.52294/e6198273-b8e3-4b63-babb-6e6b0da10669](https://doi.org/10.52294/e6198273-b8e3-4b63-babb-6e6b0da10669)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Brad Caron

**Contributors:** Soichi Hayashi

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](LICENSE).
