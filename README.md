# Columbia plots and alike

[![CC BY 4.0][cc-by-shield]][cc-by]

This repository gathers in one place all figures related to my research during my Ph.D. and afterwards.
Many people asked me many times if it was possible to get the source files behind the figures, which I then decided to make public, confident that my work will be properly cited and credit given.

If you would like to contribute to this repository, feel free to fork it and open a pull request.
It will be my pleasure to merge it in and give credit to you as appropriate.
Refer to the [CONTRIBUTING](CONTRIBUTING.md) file for more detailed information about how to add a figure to the repository.

## Using figures in you work

This work is licensed under a [Creative Commons Attribution 4.0 International License][cc-by].
By downloading any image in this repository and using it (possibly modified) in future publications, presentations, lectures and similar, you undertake to give credit to the authors citing them as appropriate.
By clicking on the `Cite this repository` button you can export the citation code e.g. in the BibTeX format.
In the [authors file](AUTHORS.yaml) you can check out who contributed to which figure and you can, therefore, limit your citation to the relevant authors, depending which figure you used.

Furthermore, a DOI is associated to this work via Zenodo and you can checkout the available releases there.
Zenodo allows you to export the citation in many more different formats than GitHub and it might be advantageous for you to export the citation entry from it.
In this case, it is encouraged to use the concept DOI rather than that of a specific version.
The former will in any case always resolve to the latest version of the repository.

If you use a PDF file which was already published in a previous article, citing such an article is clearly already enough.

[![CC BY 4.0][cc-by-image]][cc-by]

## Some technical information

All SVG files have been produced using [Inkscape](https://inkscape.org).
If you open them in versions of the software newer than that used to produce them it might be that some update will be done and, hence, the figure might be changed (typically w.r.t. to text).
For this reason, but also to make everything directly visible and usable, all existing figures have been exported as PDF files to the ***Pdf*** folder.

Furthermore, the SVG files make heavy use of layers, such that all different versions of the _"same"_ plot have the same dimensions, which makes them nice to be used in overlays or animations in presentations.
This also explain why there are much fewer SVG than PDF files.

### Technical specifications

All files in the ***Svg*** folder have been created using a consistent style, e.g. with respect to colours used and about how 3D planes have been drawn.
This is meant to stay consistent among different figures and keep using the same approach.

#### Colours and lines

Used colors are reported in the following table using the RGB `(x,y,z)` notation, where
- `x` is the **red**   content from 0 to 255;
- `y` is the **green** content from 0 to 255 and
- `z` is the **blue**  content from 0 to 255.

The width of transitions lines is `1mm` while axis are `0.3mm` thick.

<div align="center">

| Type of path or object | RGB values | Example of the colour |
| ---------------------: | :--------- | :-------------------: |
| Physical Point             |  `(0,30,150)`    | ![](https://img.shields.io/badge/Colour%20example-rgb(0,30,150))    |
| Tricritical line           |  `(255,0,0)`     | ![](https://img.shields.io/badge/Colour%20example-rgb(255,0,0))     |
| Tricritical text           |  `(255,0,0)`     | ![](https://img.shields.io/badge/Colour%20example-rgb(255,0,0))     |
| Z(2) text                  |  `(0,0,255)`     | ![](https://img.shields.io/badge/Colour%20example-rgb(0,0,255))     |
| Z(2) line                  |  `(0,102,255)`   | ![](https://img.shields.io/badge/Colour%20example-rgb(0,102,255))   |
| Z(2) region                |  `(128,179,255)` | ![](https://img.shields.io/badge/Colour%20example-rgb(128,179,255)) |
| 1st order region           |  `(255,255,150)` | ![](https://img.shields.io/badge/Colour%20example-rgb(255,255,150)) |
| 1st order text             |  `(255,80,0)`    | ![](https://img.shields.io/badge/Colour%20example-rgb(255,80,0))    |
| 1st order line             |  `(255,128,0)`   | ![](https://img.shields.io/badge/Colour%20example-rgb(255,128,0))   |
| O(4) text                  |  `(255,0,200)`   | ![](https://img.shields.io/badge/Colour%20example-rgb(255,0,200))   |
| O(4) line                  |  `(255,0,200)`   | ![](https://img.shields.io/badge/Colour%20example-rgb(255,0,200))   |
| O(4) region                |  `(255,215,255)` | ![](https://img.shields.io/badge/Colour%20example-rgb(255,215,255)) |
| 1st order triple region    |  `(170,255,204)` | ![](https://img.shields.io/badge/Colour%20example-rgb(170,255,204)) |
| 1st order triple text      |  `(0,85,34)`     | ![](https://img.shields.io/badge/Colour%20example-rgb(0,85,34))     |
| 1st order triple line      |  `(0,180,0)`     | ![](https://img.shields.io/badge/Colour%20example-rgb(0,180,0))     |
| 1st order quadruple text   |  `(128,0,128)`   | ![](https://img.shields.io/badge/Colour%20example-rgb(128,0,128))   |
| 1st order quadruple line   |  `(170,0,212)`   | ![](https://img.shields.io/badge/Colour%20example-rgb(170,0,212))   |
| Crossover region gray      |  `(240,240,240)` | ![](https://img.shields.io/badge/Colour%20example-rgb(240,240,240)) |
| Crossover region blue      |  `(212,255,255)` | ![](https://img.shields.io/badge/Colour%20example-rgb(212,255,255)) |
| 2nd order line in general  |  `(0,0,180)`     | ![](https://img.shields.io/badge/Colour%20example-rgb(0,0,180))     |
| 2nd order text in general  |  `(0,0,180)`     | ![](https://img.shields.io/badge/Colour%20example-rgb(0,0,180))     |

</div>

#### Remarks about the 3D Columbia plot

- The upper and lower planes are obtained by rotating the 2D plane by `-60 degrees` and scaling it vertically by 50%.
- The **left** backplane is obtained starting from the 2D Columbia plot's square and
    1. scaling it horizontally by `87.037%` (inverse is `114.894%`);
    1. scaling it vertically by `80.761%` (inverse is `123.822%`) and
    1. distorting vertically by `16.093 degrees`.
- The **right** backplane is obtained starting from 2D Columbia plot's square and
    1. scaling it horizontally by `49.918%` (inverse is `200.328%`);
    1. scaling it vertically by `80.761%` (inverse is `123.822%`) and
    1. distorting vertically by `-40.953 degrees`.

#### Remarks about the 3D (T, mui, mass) plot

- The **right** plane is obtained by distorting the 2D plane vertically by `-15 degrees`.
- The **left** plane is obtained by distorting the 2D plane vertically by `+15 degrees` and scaling it horizontally by `150%`.



[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg
