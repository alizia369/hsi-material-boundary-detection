# Material Based Boundary Detection in Hyperspectral Images

**Suhad Lateef Al-Khafaji, Ali Zia, Jun Zhou, Alan Wee-Chung Liew**
*International Conference on Digital Image Computing: Techniques and Applications (DICTA), Sydney, 2017, pp. 1–7*

[![Paper](https://img.shields.io/badge/Paper-DICTA%202017-blue)](https://researchportalplus.anu.edu.au/en/publications/material-based-boundary-detection-in-hyperspectral-images/) ![Language](https://img.shields.io/badge/Language-MATLAB-orange) [![License](https://img.shields.io/badge/License-BSD--style-green)](LICENSE)

> **Status.** This is the original research code behind the publication,
> prepared for release. Duplicate, backup and autosave files, data and personal
> file paths were removed and third-party code was separated into
> `third_party/`; the algorithms themselves were not modified. It is research
> code rather than a polished toolbox, and it was developed on Windows MATLAB.

## Overview

Object boundaries in hyperspectral images are hard to detect. The data are
high-dimensional, and the information that separates two materials may be
concentrated in only a few bands. Edge detectors designed for grayscale or RGB
images, or applied band by band, either miss such boundaries or respond to
texture inside a single material.

The paper takes a statistical view instead. Pairs of neighbouring pixels inside
one region have spectral-spatial features that occur together often; pairs
that straddle a material boundary occur together rarely. This repository
contains the MATLAB implementation, built as an extension of the *Crisp
Boundary Detection* toolbox by Isola et al. (ECCV 2014).

## Method

1. **Spectral-spatial features.** For each pixel, joint features are computed
   from the cube, including spectral angle, spectral-gradient angle and 3D
   Gaussian/convolution responses (`getSpectralFeatures.m`, `Spectral_Angle.m`,
   `Spectral_Grad_Angle.m`, `Conv3D.m`, `Gaussian3.m`, `Entropy.m`).
2. **Co-occurrence statistics.** Feature pairs are sampled from neighbouring
   pixels (`getSSLocalPairs.m`, `getSpectralLocalPairs.m`), and their joint
   density is estimated with kernel density estimation. Pointwise mutual
   information between neighbours gives an affinity matrix (`buildW_pmi.m`,
   `getW.m`).
3. **Boundary extraction.** Spectral clustering on the affinity matrix gives
   the boundary map (`findBoundaries.m`, `getE.m`).

## Repository structure

```
setup_paths.m                  add all code folders to the MATLAB path
Code/
  demoHSI.m                    entry point for hyperspectral cubes
  demo.m                       original RGB demo of the base toolbox
  findBoundaries.m             main boundary-detection routine
  getSpectralFeatures.m ...    hyperspectral extension
  compile.m                    builds the MEX dependencies
  eval/, evalPMI.m             evaluation
  toolboxes/                   upstream dependencies (kde, BSR, MCG, ae-multigrid)
  util/, viz/                  upstream helpers
README_crisp_boundaries.md     README of the base toolbox
installation_issues.txt        build notes of the base toolbox
```

## Requirements

- MATLAB (developed 2016–2017)
- Image Processing Toolbox; Statistics and Machine Learning Toolbox (`kmeans`)
- A C/C++ compiler configured for MATLAB `mex`

## Getting started

```matlab
>> cd hsi-material-boundary-detection
>> setup_paths
>> cd Code
>> compile        % once, builds the MEX files
>> demoHSI        % choose a hyperspectral cube in the file dialog
```

`demoHSI` accepts `.mat` cubes (an H×W×B array, or a struct with field `ref`)
and ENVI `.hdr`/`.dat` files. It infers band wavelengths from the number of
bands and displays the detected boundaries. `evalPMI.m` and `Code/eval/` run
the quantitative evaluation.

## Data

The hyperspectral scenes used in the paper are not distributed with this
repository; see `data/README.md`.

## Notes on reproducibility

- The UCM segmentation part of the base toolbox does not compile on Windows
  (see `installation_issues.txt`). Boundary detection itself is unaffected.
- Feature choices and sampling parameters are set in `setEnvironment.m`.

## Citation

If you use this code, please cite:

```bibtex
@inproceedings{alkhafaji2017material,
  title     = {Material Based Boundary Detection in Hyperspectral Images},
  author    = {Al-Khafaji, Suhad Lateef and Zia, Ali and Zhou, Jun and Liew, Alan Wee-Chung},
  booktitle = {International Conference on Digital Image Computing: Techniques and Applications (DICTA)},
  pages     = {1--7},
  year      = {2017}
}

@inproceedings{isola2014crisp,
  title     = {Crisp Boundary Detection Using Pointwise Mutual Information},
  author    = {Isola, Phillip and Zoran, Daniel and Krishnan, Dilip and Adelson, Edward H.},
  booktitle = {European Conference on Computer Vision (ECCV)},
  year      = {2014}
}
```

A `CITATION.cff` file is included, so GitHub's **Cite this repository** button gives the same reference.

## Licence and third-party code

This repository is a derivative of Phillip Isola's crisp-boundaries toolbox.
Its BSD-style licence is kept in `LICENSE` and applies to the modifications as
well. The toolboxes bundled in `Code/toolboxes/` keep their own terms.

## Acknowledgements

The original work was carried out at Griffith University, Australia. We thank Phillip Isola and co-authors for releasing the crisp-boundaries toolbox on which this code is built.

## Contact

Questions and bug reports are welcome through [GitHub issues](https://github.com/alizia369/hsi-material-boundary-detection/issues).
Ali Zia, La Trobe University — [www.ali-zia.me](https://www.ali-zia.me)

## Related repositories

This repository is one of a set released together from the same line of work on hyperspectral computer vision:

- [`hsi-3d-reconstruction`](https://github.com/alizia369/hsi-3d-reconstruction): 3D reconstruction from hyperspectral images (WACV 2015)
- [`hsi-relative-depth-estimation`](https://github.com/alizia369/hsi-relative-depth-estimation): Relative depth from a hyperspectral cube (DICTA 2015)
- [`hsi-chromatic-defocus-depth`](https://github.com/alizia369/hsi-chromatic-defocus-depth): Chromatic aberration + defocus for relative depth (IEEE TIP 2021)
- [`hsi-occluded-object-detection`](https://github.com/alizia369/hsi-occluded-object-detection): Occluded object detection (PhD thesis, arXiv forthcoming)
- [`sugarcane-smut-hsi`](https://github.com/alizia369/sugarcane-smut-hsi): Early sugarcane smut detection (IVCNZ 2021)
- [`hsi-matlab-utils`](https://github.com/alizia369/hsi-matlab-utils): Shared hyperspectral I/O and normalisation helpers
