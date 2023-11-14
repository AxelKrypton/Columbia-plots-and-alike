#!/usr/bin/env bash

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
set -euo pipefail
shopt -s inherit_errexit
trap 'printf "\n"' EXIT

for prog in git latexmk pdftoppm; do
    if ! hash "${prog}"; then
        printf "\e[91m Program ${prog} not found, but needed.\n"
        exit 1
    fi
done

readonly script_path=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly pdf_folder_path="${script_path}/Pdf"
readonly images_thumb_folder_path="${script_path}/assets/images/thumbs"
readonly images_full_folder_path="${script_path}/assets/images/fulls"
readonly images_metadata_folder_path="${script_path}/_images"
readonly images=(
    'CP_blur'
    'CP_2order_all_with_Nf3'
    'CP_2order_with_Nf3'
    'CP_1order_with_Nf3'
    'CP_1order_hole_with_Nf3'
#    'CP_3D_1order'
#    'CP_3D_1order_backplane'
#    'CP_3D_2order'
#    'CP_3D_2order_all'
#    'CP_3D_2order_backplane'
#    'CP_3D_2order_full_backplane'
#    'CP-like_Wilson.pdf'
#    'CP-like_a-m.pdf'
#    'CP-like_m-Nf_2-order.pdf'
#    'CP_RW'
#    'LCP_1-order.pdf'
#    'LCP_2-order.pdf'
#    'PD_T-m-Nf.pdf'
#    'PD_T-m-Nf_no-surface.pdf'
#    'PD_T-m.pdf'
#    'PD_Wilson.pdf'
#    'QCD_Nf2p1'
#    'QCD_Nf2p1_massless_ud'
#    'QCD_Nf2_massive'
#    'QCD_Nf2_massless_A'
#    'QCD_Nf2_massless_B'
#    'QCD_Nf2_massless_C'
#    'QCD_Nf2_massless_D'
#    'QCD_Nf2_massless_E'
#    'QCD_Nf2_massless_F'
#    'QCD_experiments'
#    'QCD_experiments_blur'
#    'RW_T_mass_plane'
#    'RW_T_mu_mass_diagram_1order'
#    'RW_T_mu_mass_diagram_2order'
#    'RW_T_mu_plane'
#    'RW_Zero_mass_1order'
#    'RW_high_mass'
#    'RW_high_mass_with_co'
#    'RW_low_mass'
#    'RW_low_mass_with_co'
#    'RW_middle_mass'
#    'RW_middle_mass_with_co'
#    'RW_tric_high_mass'
#    'RW_tric_high_mass_with_co'
#    'RW_tric_low_mass'
#    'RW_tric_low_mass_with_co'
#    'RW_very_high_mass'
#    'RW_very_low_mass'
#    'RW_zero_mass_2order'
)

function Refer_To_Figure()
{
    local -r prefix=${1- } ref=${3:-0} postfix=${4-}
    if [[ ! ${ref} =~ ^[01]$ ]]; then
        printf "\n\e[91m Invalid reference '${ref}' passed to ${FUNCNAME}.\n" >&2
    fi
    printf '%sFigure %s of {{ site.ref[%d] }}%s.' "${prefix}" "$2" "${ref}" "${postfix}"
}

declare -rgA CP_1order_with_Nf3=(
    [title]='Columbia plot on coarse lattices'
    [caption]="$(Refer_To_Figure '' '1(a)' '1' '')"
    [pdf_file]='CP_1-order_with_Nf3.pdf'
    [svg_file]=''
)
declare -rgA CP_2order_with_Nf3=(
    [title]='Columbia plot historical second order scenario'
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='CP_2-order_with_Nf3.pdf'
    [svg_file]=''
)
declare -rgA CP_2order_all_with_Nf3=(
    [title]='Columbia plot in the continuum limit'
    [caption]="$(Refer_To_Figure '' '13' '1' '')"
    [pdf_file]='CP_2-order_all_with_Nf3.pdf'
    [svg_file]=''
)
declare -rgA CP_1order_hole_with_Nf3=(
    [title]='Fancy Columbia plot scenario'
    [caption]="$(Refer_To_Figure 'Refined version of' '2.5(c)' '' '')"
    [pdf_file]='CP_1-order_hole_with_Nf3.pdf'
    [svg_file]=''
)
declare -rgA CP_blur=(
    [title]='Columbia plot historical dilemma'
    [caption]="$(Refer_To_Figure 'Refined version of' '2.4' '' '')"
    [pdf_file]='CP_blur.pdf'
    [svg_file]=''
)
declare -rgA CP_3D_1order=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='CP_3D_1-order.pdf'
    [svg_file]=''
)
declare -rgA CP_3D_1order_backplane=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='CP_3D_1-order_backplane.pdf'
    [svg_file]=''
)
declare -rgA CP_3D_2order=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='CP_3D_2-order.pdf'
    [svg_file]=''
)
declare -rgA CP_3D_2order_all=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='CP_3D_2-order_all.pdf'
    [svg_file]=''
)
declare -rgA CP_3D_2order_backplane=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='CP_3D_2-order_backplane.pdf'
    [svg_file]=''
)
declare -rgA CP_3D_2order_full_backplane=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='CP_3D_2-order_full_backplane.pdf'
    [svg_file]=''
)
declare -rgA CPlike_Wilson=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='CP-like_Wilson.pdf'
    [svg_file]=''
)
declare -rgA CPlike_a_m=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='CP-like_a-m.pdf'
    [svg_file]=''
)
declare -rgA CPlike_m_Nf_2order=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='CP-like_m-Nf_2-order.pdf'
    [svg_file]=''
)
declare -rgA CP_RW=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='CP_RW.pdf'
    [svg_file]=''
)
declare -rgA LCP_1order=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='LCP_1-order.pdf'
    [svg_file]=''
)
declare -rgA LCP_2order=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='LCP_2-order.pdf'
    [svg_file]=''
)
declare -rgA PD_T_m_Nf=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='PD_T-m-Nf.pdf'
    [svg_file]=''
)
declare -rgA PD_T_m_Nf_no_surface=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='PD_T-m-Nf_no-surface.pdf'
    [svg_file]=''
)
declare -rgA PD_T_m=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='PD_T-m.pdf'
    [svg_file]=''
)
declare -rgA PD_Wilson=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='PD_Wilson.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2p1=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='QCD_Nf2+1.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2p1_massless_ud=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='QCD_Nf2+1_massless_ud.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_massive=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='QCD_Nf2_massive.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_massless_A=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='QCD_Nf2_massless_A.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_massless_B=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='QCD_Nf2_massless_B.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_massless_C=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='QCD_Nf2_massless_C.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_massless_D=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='QCD_Nf2_massless_D.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_massless_E=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='QCD_Nf2_massless_E.pdf'
    [svg_file]=''
)
declare -rgA QCD_Nf2_massless_F=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='QCD_Nf2_massless_F.pdf'
    [svg_file]=''
)
declare -rgA QCD_experiments=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='QCD_experiments.pdf'
    [svg_file]=''
)
declare -rgA QCD_experiments_blur=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='QCD_experiments_blur.pdf'
    [svg_file]=''
)
declare -rgA RW_T_mass_plane=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_T_mass_plane.pdf'
    [svg_file]=''
)
declare -rgA RW_T_mu_mass_diagram_1order=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_T_mu_mass_diagram_1-order.pdf'
    [svg_file]=''
)
declare -rgA RW_T_mu_mass_diagram_2order=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_T_mu_mass_diagram_2-order.pdf'
    [svg_file]=''
)
declare -rgA RW_T_mu_plane=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_T_mu_plane.pdf'
    [svg_file]=''
)
declare -rgA RW_Zero_mass_1order=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_Zero_mass_1-order.pdf'
    [svg_file]=''
)
declare -rgA RW_high_mass=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_high_mass.pdf'
    [svg_file]=''
)
declare -rgA RW_high_mass_with_co=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_high_mass_with_c-o.pdf'
    [svg_file]=''
)
declare -rgA RW_low_mass=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_low_mass.pdf'
    [svg_file]=''
)
declare -rgA RW_low_mass_with_co=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_low_mass_with_c-o.pdf'
    [svg_file]=''
)
declare -rgA RW_middle_mass=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_middle_mass.pdf'
    [svg_file]=''
)
declare -rgA RW_middle_mass_with_co=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_middle_mass_with_c-o.pdf'
    [svg_file]=''
)
declare -rgA RW_tric_high_mass=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_tric_high_mass.pdf'
    [svg_file]=''
)
declare -rgA RW_tric_high_mass_with_co=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_tric_high_mass_with_c-o.pdf'
    [svg_file]=''
)
declare -rgA RW_tric_low_mass=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_tric_low_mass.pdf'
    [svg_file]=''
)
declare -rgA RW_tric_low_mass_with_co=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_tric_low_mass_with_c-o.pdf'
    [svg_file]=''
)
declare -rgA RW_very_high_mass=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_very_high_mass.pdf'
    [svg_file]=''
)
declare -rgA RW_very_low_mass=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_very_low_mass.pdf'
    [svg_file]=''
)
declare -rgA RW_zero_mass_2order=(
    [title]=''
    [caption]="$(Refer_To_Figure '' '' '' '')"
    [pdf_file]='RW_zero_mass_2-order.pdf'
    [svg_file]=''
)

function Convert_PDF_to_JPG()
{
    local -r pdf_file="$1" jpg_file="$2"
    pdftoppm -jpeg -r 300 -singlefile "${pdf_file}" "${jpg_file}"
}

function Create_Thumbnail()
{
    local pdf_filename output_number tmp_folder tex_file
    pdf_filename="$1"
    output_number="$2"
    tmp_folder=$(mktemp -d)
    tex_file='tmp.tex'
    cd "${tmp_folder}"
    cp "${pdf_folder_path}/${pdf_filename}" .
    # Compile each pdf into another one with white background
    cat > "${tex_file}" <<TEX
\documentclass{article}
\usepackage{graphicx,tikz}
\usepackage[paperwidth=12cm, paperheight=8cm]{geometry}

\begin{document}
    \thispagestyle{empty}
    \begin{tikzpicture}[remember picture, overlay]
        \node[yshift=3mm] at (current page.center){\includegraphics[width=0.75\textwidth]{${pdf_filename}}};
    \end{tikzpicture}
\end{document}
TEX
    # Compile PDF into new one with correct dimensions and then convert it to JPG, moving it to the correct place
    latexmk -pdf -quiet "${tex_file}" &> /dev/null
    Convert_PDF_to_JPG "${tex_file/%.tex/.pdf}" "${output_number}"
    mv "${output_number}.jpg" "${images_thumb_folder_path}"
    # Convert the full image, too
    Convert_PDF_to_JPG "${pdf_filename}" "${output_number}"
    mv "${output_number}.jpg" "${images_full_folder_path}"
    cd "${script_path}"
    rm -r "${tmp_folder}"
}

function Create_Image_Metadata_File()
{
    local -r output_number="$1"
    local field
    {
        printf '%s\n' '---'
        for field in title caption {pdf,svg}_file; do
            printf "${field}: ${array_ref[${field}]}\n"
        done
        printf '%s\n' '---'
    } > "${images_metadata_folder_path}/${output_number}.md"
}

# Since the webpage is on an orphan branch and the PDF files on main, we'd need
# to switch branch. However, if we then simply put files in the correct folders,
# it would be basically difficult to switch back overwriting existing branches in
# the orphan branch. Hence, we stay on the orphan branch and we get the Pdf folder
# from main, unstage it (checkout automatically stages) and then work and delete it.
git checkout main -- Pdf
git restore -S Pdf

counter=1
readonly number_of_images=${#images[@]}
readonly number_of_digits=${#number_of_images}
printf '\n'
for image in "${images[@]}"; do
    if ! declare -p "${image}" &>/dev/null; then
        printf "\e[93mWARNING: Metadata '${image}' not found, skipping image!\e[0m\n"
        continue
    fi
    declare -n array_ref=${image}
    number=$(printf '%0*d' ${number_of_digits} ${counter})
    printf "\n\n\n\e[3A\e[92mINFO: Image ${number} will be added to gallery$(tput sc) -> ${image})...\e[0m"
    Create_Thumbnail "${array_ref[pdf_file]}" ${number}
    Create_Image_Metadata_File ${number}
    printf "$(tput rc)\e[K\e[96m ...done!\e[0m\n"
    (( counter++ ))
done

# Remove Pdf folder
git clean -f -- Pdf > /dev/null
