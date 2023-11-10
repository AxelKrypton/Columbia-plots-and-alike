#!/bin/usr/env bash

#------------------------------------------------------------------------------#
# (c) 2023 Alessandro Sciarra <sciarra@itp.uni-frankfurt.de>
#
# This script is meant to be used to populate or reorder the images in the
# gallery. All the images metadata are stores in this script in associative
# arrays and the script will use these and the files in the repository to:
#
#  - create thumbnails from the PDF, using LaTeX to set the ideal size and adding a
#    white background;
#  - produce light jpeg images for the website converting the PDF;
#  - write metadata .md files for Jekyll in the _images folder.
#
# The arrays are structured in a clever way to populate metadata:
#  - the array keys are the YAML keys of the metadata;
#  - the array entries are the values ofr YAML files;
#  - the names of the arrays are stored in another array which
#    determines the order of the images in the website.
#------------------------------------------------------------------------------#

readonly images=(

)

declare -rgA ColumbiaPlot=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot3D_1scenario=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot3D_1scenario.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot3D_O4scenario=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot3D_O4scenario.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot3D_O4scenario_all=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot3D_O4scenario_all.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot3D_O4scenario_full_backplane=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot3D_O4scenario_full_backplane.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlotRW=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlotRW.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot_1scenario=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot_1scenario.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot_1scenario_hole=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot_1scenario_hole.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot_1scenario_hole_withNf3=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot_1scenario_hole_withNf3.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot_1scenario_withNf3=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot_1scenario_withNf3.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot_Backplane_1scenario=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot_Backplane_1scenario.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot_Backplane_O4=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot_Backplane_O4.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot_O4scenario=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot_O4scenario.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot_O4scenario_all=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot_O4scenario_all.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot_O4scenario_all_withNf3=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot_O4scenario_all_withNf3.pdf'
    [svg_file]=''
)
declare -rgA ColumbiaPlot_O4scenario_withNf3=(
    [title]=''
    [caption]=''
    [pdf_file]='ColumbiaPlot_O4scenario_withNf3.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2+1=(
    [title]=''
    [caption]=''
    [pdf_file]='QCD_Nf2+1.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2+1_massless_ud=(
    [title]=''
    [caption]=''
    [pdf_file]='QCD_Nf2+1_massless_ud.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_massive=(
    [title]=''
    [caption]=''
    [pdf_file]='QCD_Nf2_massive.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_masslessA=(
    [title]=''
    [caption]=''
    [pdf_file]='QCD_Nf2_masslessA.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_masslessB=(
    [title]=''
    [caption]=''
    [pdf_file]='QCD_Nf2_masslessB.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_masslessC=(
    [title]=''
    [caption]=''
    [pdf_file]='QCD_Nf2_masslessC.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_masslessD=(
    [title]=''
    [caption]=''
    [pdf_file]='QCD_Nf2_masslessD.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_masslessE=(
    [title]=''
    [caption]=''
    [pdf_file]='QCD_Nf2_masslessE.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_masslessF=(
    [title]=''
    [caption]=''
    [pdf_file]='QCD_Nf2_masslessF.pdf'
    [svg_file]=''
)
declare -rgA QCD_experiments=(
    [title]=''
    [caption]=''
    [pdf_file]='QCD_experiments.pdf'
    [svg_file]=''
)
declare -rgA QCD_experiments_blur=(
    [title]=''
    [caption]=''
    [pdf_file]='QCD_experiments_blur.pdf'
    [svg_file]=''
)
declare -rgA RW_HighMass=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_HighMass.pdf'
    [svg_file]=''
)
declare -rgA RW_HighMassWithCrossover=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_HighMassWithCrossover.pdf'
    [svg_file]=''
)
declare -rgA RW_IntermidiateMass=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_IntermidiateMass.pdf'
    [svg_file]=''
)
declare -rgA RW_IntermidiateMassWithCrossover=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_IntermidiateMassWithCrossover.pdf'
    [svg_file]=''
)
declare -rgA RW_LowMass=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_LowMass.pdf'
    [svg_file]=''
)
declare -rgA RW_LowMassWithCrossover=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_LowMassWithCrossover.pdf'
    [svg_file]=''
)
declare -rgA RW_T_mu_plane=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_T_mu_plane.pdf'
    [svg_file]=''
)
declare -rgA RW_Tmass_plane=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_Tmass_plane.pdf'
    [svg_file]=''
)
declare -rgA RW_Tmumass_diagram=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_Tmumass_diagram.pdf'
    [svg_file]=''
)
declare -rgA RW_Tmumass_diagram_O4=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_Tmumass_diagram_O4.pdf'
    [svg_file]=''
)
declare -rgA RW_TricriticalHighMass=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_TricriticalHighMass.pdf'
    [svg_file]=''
)
declare -rgA RW_TricriticalHighMassWithCrossover=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_TricriticalHighMassWithCrossover.pdf'
    [svg_file]=''
)
declare -rgA RW_TricriticalLowMass=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_TricriticalLowMass.pdf'
    [svg_file]=''
)
declare -rgA RW_TricriticalLowMassWithCrossover=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_TricriticalLowMassWithCrossover.pdf'
    [svg_file]=''
)
declare -rgA RW_VeryHighMass=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_VeryHighMass.pdf'
    [svg_file]=''
)
declare -rgA RW_VeryLowMass=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_VeryLowMass.pdf'
    [svg_file]=''
)
declare -rgA RW_ZeroMass=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_ZeroMass.pdf'
    [svg_file]=''
)
declare -rgA RW_ZeroMass_O4=(
    [title]=''
    [caption]=''
    [pdf_file]='RW_ZeroMass_O4.pdf'
    [svg_file]=''
)




# Compile each pdf into another one with white background
cat <<TEX
\documentclass{article}
\usepackage{graphicx,tikz}
\usepackage[paperwidth=12cm, paperheight=8cm]{geometry}

\begin{document}
    \thispagestyle{empty}
    \begin{tikzpicture}[remember picture, overlay]
        \node[yshift=3mm] at (current page.center){\includegraphics[width=0.75\textwidth]{Pdf/ColumbiaPlot}};
    \end{tikzpicture}
\end{document}
TEX

# Convert pdf into jpeg
#
# pdftoppm -jpeg -r 300 test.pdf output


