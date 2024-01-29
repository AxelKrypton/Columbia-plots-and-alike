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

for prog in git latexmk pdftoppm yq; do
    if ! hash "${prog}"; then
        printf "\e[91m Program ${prog} not found, but needed.\e[0m\n"
        exit 1
    fi
done

readonly script_path=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly site_conf_file="_config.yml"
readonly authors_file="AUTHORS.yaml"
readonly pdf_folder_path="${script_path}/Pdf"
readonly images_thumb_folder_path="${script_path}/assets/images/thumbs"
readonly images_full_folder_path="${script_path}/assets/images/fulls"
readonly images_metadata_folder_path="${script_path}/_images"
readonly images=(
    'Notation'
    'CP_blur'
    'CP_2order_all_with_Nf3'
    'CP_2order_with_Nf3'
    'CP_1order_with_Nf3'
    'CP_1order_hole_with_Nf3'
    'CP_RW'
    'CP_3D_1order'
    'CP_3D_2order'
    'CP_3D_2order_all'
    'CP_3D_2order_full_backplane'
    'CP_3D_1order_backplane'
    'CP_3D_2order_backplane'
    'CPlike_m_Nf_1order'
    'CPlike_m_Nf_2order'
    'QCD_experiments'
    'QCD_Nf2_massive'
    'QCD_Nf2_massless_A'
    'QCD_Nf2_massless_B'
    'QCD_Nf2_massless_C'
    'QCD_Nf2_massless_D'
    'QCD_Nf2_massless_E'
    'QCD_Nf2_massless_F'
    'QCD_Nf2p1'
    'QCD_Nf2p1_massless_ud'
    'RW_T_mu_plane'
    'RW_T_mass_plane'
    'RW_T_mu_mass_diagram_1order'
    'RW_T_mu_mass_diagram_2order'
    'RW_Zero_mass_1order'
    'RW_zero_mass_2order'
    'RW_very_low_mass'
    'RW_low_mass'
    'RW_tric_low_mass'
    'RW_middle_mass'
    'RW_tric_high_mass'
    'RW_high_mass'
    'RW_very_high_mass'
    'PD_T_m'
    'CPlike_a_m'
    'LCP_1order'
    'LCP_2order'
    'PD_Wilson'
    'CPlike_Wilson'
    'PD_T_m_Nf'
    'PD_T_m_Nf_no_surface'
)

function Get_Markdown_Reference_Link()
{
    # References (see _config.yml file):
    #  - 0 -> Alessandro Sciarra's Ph.D. thesis (2016)
    #  - 1 -> https://arxiv.org/pdf/2107.12739.pdf -> Cuteri, Philipsen, Sciarra JHEP paper
    #  - 2 -> https://arxiv.org/pdf/1711.05658.pdf -> Cuteri, Philipsen, Sciarra PRD paper
    #
    # NOTE: Since it is not possible to use the jekyll-liquify plugin
    #            https://github.com/gemfarmer/jekyll-liquify
    #       on GitHub pages, we extract here the references from the site configuration file
    #       instead of using {{ site.ref[...] }} syntax. We use yq for that purpose.
    if [[ ! -f "${site_conf_file}" ]]; then
        printf "\n\e[91m File '${site_conf_file}' needed in ${FUNCNAME} function.\n" >&2
    else
        yq ".ref[$1]" "${site_conf_file}"
    fi
}

function Refer_To_Figure()
{
    local -r prefix=${1- } ref=${3:-0} postfix=${4-}
    if [[ ! ${ref} =~ ^[0-2]$ ]]; then
        printf "\n\e[91m Invalid reference '${ref}' passed to ${FUNCNAME} function.\n" >&2
    elif [[ ! -f "${site_conf_file}" ]]; then
        printf "\n\e[91m File '${site_conf_file}' needed in ${FUNCNAME} function.\n" >&2
    fi
    local -r markdown_link="$(Get_Markdown_Reference_Link ${ref})"
    printf '%sFigure %s of %s%s.' "${prefix}" "$2" "${markdown_link}" "${postfix}"
}

declare -rgA Notation=(
    [title]='Notation used in the figures'
    [caption]="Refer to Table 2.1 of $(Get_Markdown_Reference_Link 0) for further information."
    [pdf_file]='Notation.pdf'
    [svg_file]='""'
)
declare -rgA CP_1order_with_Nf3=(
    [title]='Columbia plot on coarse lattices'
    [caption]="$(Refer_To_Figure '' '1(a)' '1' '')"
    [pdf_file]='CP_1-order_with_Nf3.pdf'
    [svg_file]='CP.svg'
)
declare -rgA CP_2order_with_Nf3=(
    [title]='Columbia plot historical second-order scenario'
    [caption]="$(Refer_To_Figure 'Refined version of ' '2.5(b)' '' '')"
    [pdf_file]='CP_2-order_with_Nf3.pdf'
    [svg_file]='CP.svg'
)
declare -rgA CP_2order_all_with_Nf3=(
    [title]='Columbia plot in the continuum limit'
    [caption]="$(Refer_To_Figure '' '13' '1' '')"
    [pdf_file]='CP_2-order_all_with_Nf3.pdf'
    [svg_file]='CP.svg'
)
declare -rgA CP_1order_hole_with_Nf3=(
    [title]='Fancy Columbia plot scenario'
    [caption]="$(Refer_To_Figure 'Refined version of ' '2.5(c)' '' '')"
    [pdf_file]='CP_1-order_hole_with_Nf3.pdf'
    [svg_file]='CP.svg'
)
declare -rgA CP_blur=(
    [title]='Columbia plot historical dilemma'
    [caption]="$(Refer_To_Figure 'Refined version of ' '2.4' '' '')"
    [pdf_file]='CP_blur.pdf'
    [svg_file]='CP.svg'
)
declare -rgA CP_3D_1order=(
    [title]='3D Columbia plot on coarse lattices'
    [caption]="$(Refer_To_Figure '' '2.12(a)' '' '')"
    [pdf_file]='CP_3D_1-order.pdf'
    [svg_file]='CP_3D.svg'
)
declare -rgA CP_3D_1order_backplane=(
    [title]='Chiral region of the $N_\mathrm{f}=2$ plane on coarse lattices'
    [caption]="$(Refer_To_Figure '' '2.12(b)' '' '')"
    [pdf_file]='CP_3D_1-order_backplane.pdf'
    [svg_file]='CP_Backplane.svg'
)
declare -rgA CP_3D_2order=(
    [title]='3D Columbia plot in the historical second-order scenario'
    [caption]="$(Refer_To_Figure '' '2.13(a)' '' '')"
    [pdf_file]='CP_3D_2-order.pdf'
    [svg_file]='CP_3D.svg'
)
declare -rgA CP_3D_2order_backplane=(
    [title]='Historical scenario for chiral region of the $N_\mathrm{f}=2$ plane'
    [caption]="$(Refer_To_Figure '' '2.13(b)' '' '')"
    [pdf_file]='CP_3D_2-order_backplane.pdf'
    [svg_file]='CP_Backplane.svg'
)
declare -rgA CP_3D_2order_all=(
    [title]='Alternative scenario for 3D Columbia plot'
    [caption]="$(Refer_To_Figure '' '2.14' '' '')"
    [pdf_file]='CP_3D_2-order_all.pdf'
    [svg_file]='CP_3D.svg'
)
declare -rgA CP_3D_2order_full_backplane=(
    [title]='Plausible continuum limit 3D Columbia plot'
    [caption]='If the chiral first-order region is a lattice artefact for all values of the purely imaginary chemical potential, then it should vanish in the continuum limit.'
    [pdf_file]='CP_3D_2-order_full_backplane.pdf'
    [svg_file]='CP_3D.svg'
)
declare -rgA CPlike_Wilson=(
    [title]='Columbia-like plot for Wilson fermions'
    [caption]="$(Refer_To_Figure '' '11(b)' '1' '')"
    [pdf_file]='CP-like_Wilson.pdf'
    [svg_file]='CP_Wilson.svg'
)
declare -rgA CPlike_a_m=(
    [title]='Columbia-like plot for the $(a,m_{u,d})$ plane'
    [caption]="$(Refer_To_Figure '' '2' '1' '')"
    [pdf_file]='CP-like_a-m.pdf'
    [svg_file]='CP_a_m.svg'
)
declare -rgA CPlike_m_Nf_1order=(
    [title]='Columbia plot for mass-degenerate quarks on coarse lattices'
    [caption]="$(Refer_To_Figure 'Refined version of ' '2(a)' '2' '')"
    [pdf_file]='CP-like_m-Nf_1-order.pdf'
    [svg_file]='CP_m-Nf.svg'
)
declare -rgA CPlike_m_Nf_2order=(
    [title]='Columbia plot for mass-degenerate quarks on finer lattices'
    [caption]="$(Refer_To_Figure 'Refined version of ' '2(b)' '2' '')"
    [pdf_file]='CP-like_m-Nf_2-order.pdf'
    [svg_file]='CP_m-Nf.svg'
)
declare -rgA CP_RW=(
    [title]='Roberge-Weiss Columbia plot'
    [caption]="$(Refer_To_Figure '' '2.10' '' '')"
    [pdf_file]='CP_RW.pdf'
    [svg_file]='CP_RW.svg'
)
declare -rgA LCP_1order=(
    [title]='First-order continuum transition'
    [caption]="$(Refer_To_Figure '' '10(a)' '1' '')"
    [pdf_file]='LCP_1-order.pdf'
    [svg_file]='LCP.svg'
)
declare -rgA LCP_2order=(
    [title]='Second-order continuum transition'
    [caption]="$(Refer_To_Figure '' '10(b)' '1' '')"
    [pdf_file]='LCP_2-order.pdf'
    [svg_file]='LCP.svg'
)
declare -rgA PD_T_m_Nf=(
    [title]='Possible $(T, m, N_\mathrm{f})$ phase diagram on the lattice'
    [caption]="$(Refer_To_Figure '' '5' '1' '')"
    [pdf_file]='PD_T-m-Nf.pdf'
    [svg_file]='T_m_nf.svg'
)
declare -rgA PD_T_m_Nf_no_surface=(
    [title]='Suggested continuum $(T, m, N_\mathrm{f})$ phase diagram'
    [caption]="$(Refer_To_Figure '' '14' '1' '')"
    [pdf_file]='PD_T-m-Nf_no-surface.pdf'
    [svg_file]='T_m_nf.svg'
)
declare -rgA PD_T_m=(
    [title]='Sketch of the $(T, m_{u,d})$ phase diagram'
    [caption]="$(Refer_To_Figure '' '3' '1' '')"
    [pdf_file]='PD_T-m.pdf'
    [svg_file]='Three_states.svg'
)
declare -rgA PD_Wilson=(
    [title]='Schematic bare parameter Wilson phase diagram'
    [caption]="$(Refer_To_Figure '' '11(a)' '1' '')"
    [pdf_file]='PD_Wilson.pdf'
    [svg_file]='CP_Wilson.svg'
)
declare -rgA QCD_Nf2p1=(
    [title]='Conjectured QCD phase diagram'
    [caption]="$(Refer_To_Figure '' '2.3(b)' '' '')"
    [pdf_file]='QCD_Nf2+1.pdf'
    [svg_file]='QCD_Nf2+1.svg'
)
declare -rgA QCD_Nf2p1_massless_ud=(
    [title]='Conjectured QCD phase diagram with $m_{u,d}=0$'
    [caption]="$(Refer_To_Figure '' '2.3(a)' '' '')"
    [pdf_file]='QCD_Nf2+1_massless_ud.pdf'
    [svg_file]='QCD_Nf2+1.svg'
)
declare -rgA QCD_Nf2_massive=(
    [title]='Plausible scenario for two-flavours QCD phase diagram'
    [caption]="$(Refer_To_Figure '' '2.2' '' '')"
    [pdf_file]='QCD_Nf2_massive.pdf'
    [svg_file]='QCD_Nf2.svg'
)
# Do for loop to avoid duplication. This bash code is border line and
# declare argument must be quoted to make the shell parser accept it.
# I would not use this in a larger codebase, though.
#   -> https://unix.stackexchange.com/q/573179/370049
for label in {A..F}; do
    declare -rgA "QCD_Nf2_massless_${label}=(
        [title]='Possible two-flavours QCD phase diagram'
        [caption]=\"$(Refer_To_Figure '' "2.1(${label,})" '' '')\"
        [pdf_file]=QCD_Nf2_massless_${label}.pdf
        [svg_file]='QCD_Nf2.svg'
    )"
done
declare -rgA QCD_experiments=(
    [title]='Conjectured phase diagram of strong interacting matter'
    [caption]="$(Refer_To_Figure '' '1' '' '')"
    [pdf_file]='QCD_experiments_blur.pdf'
    [svg_file]='QCD_experiments.svg'
)
declare -rgA RW_T_mass_plane=(
    [title]='The $(T, m_q)$ plane at $\mu_I=\mu_I^{RW}$'
    [caption]="$(Refer_To_Figure '' '2.7(b)' '' '')"
    [pdf_file]='RW_T_mass_plane.pdf'
    [svg_file]='RW_T-mass_plane.svg'
)
declare -rgA RW_T_mu_mass_diagram_1order=(
    [title]='$N_\mathrm{f}=3$ QCD phase diagram in the $(T, \mu, m_q)$ space on coarse lattices'
    [caption]="$(Refer_To_Figure '' '2.8' '' '')"
    [pdf_file]='RW_T_mu_mass_diagram_1-order.pdf'
    [svg_file]='RW_T-mu-mass_diagram.svg'
)
declare -rgA RW_T_mu_mass_diagram_2order=(
    [title]='$N_\mathrm{f}=2$ QCD phase diagram in the $(T, \mu, m_q)$ space'
    [caption]="$(Refer_To_Figure '' '2.11' '' '')"
    [pdf_file]='RW_T_mu_mass_diagram_2-order.pdf'
    [svg_file]='RW_T-mu-mass_diagram.svg'
)
declare -rgA RW_T_mu_plane=(
    [title]='A view of the QCD phase diagram at imaginary chemical potential'
    [caption]="$(Refer_To_Figure '' '2.7(a)' '' '')"
    [pdf_file]='RW_T_mu_plane.pdf'
    [svg_file]='RW_generic.svg'
)
declare -rgA RW_Zero_mass_1order=(
    [title]='First-order scenario of $\mu_I$ phase diagram at $m_q=0$'
    [caption]="$(Refer_To_Figure '' '2.9(a)' '' '')"
    [pdf_file]='RW_Zero_mass_1-order.pdf'
    [svg_file]='RW_T-mu_plane.svg'
)
declare -rgA RW_zero_mass_2order=(
    [title]='Second-order scenario of $\mu_I$ phase diagram at $m_q=0$'
    [caption]="$(Refer_To_Figure '' '2.11(b)' '' '')"
    [pdf_file]='RW_zero_mass_2-order.pdf'
    [svg_file]='RW_T-mu_plane.svg'
)
declare -rgA RW_very_low_mass=(
    [title]='$\mu_I$ phase diagram at very low masses'
    [caption]="$(Refer_To_Figure '' '2.9(b)' '' '')"
    [pdf_file]='RW_very_low_mass.pdf'
    [svg_file]='RW_T-mu_plane.svg'
)
declare -rgA RW_low_mass=(
    [title]='$\mu_I$ phase diagram at low masses'
    [caption]="$(Refer_To_Figure '' '2.9(c)' '' '')"
    [pdf_file]='RW_low_mass_with_c-o.pdf'
    [svg_file]='RW_T-mu_plane.svg'
)
declare -rgA RW_tric_low_mass=(
    [title]='$\mu_I$ phase diagram at low tricritical mass'
    [caption]="$(Refer_To_Figure '' '2.9(d)' '' '')"
    [pdf_file]='RW_tric_low_mass_with_c-o.pdf'
    [svg_file]='RW_T-mu_plane.svg'
)
declare -rgA RW_middle_mass=(
    [title]='$\mu_I$ phase diagram at intermediate masses'
    [caption]="$(Refer_To_Figure '' '2.9(e)' '' '')"
    [pdf_file]='RW_middle_mass_with_c-o.pdf'
    [svg_file]='RW_T-mu_plane.svg'
)
declare -rgA RW_tric_high_mass=(
    [title]='$\mu_I$ phase diagram at high tricritical mass'
    [caption]="$(Refer_To_Figure '' '2.9(f)' '' '')"
    [pdf_file]='RW_tric_high_mass_with_c-o.pdf'
    [svg_file]='RW_T-mu_plane.svg'
)
declare -rgA RW_high_mass=(
    [title]='$\mu_I$ phase diagram at high masses'
    [caption]="$(Refer_To_Figure '' '2.9(g)' '' '')"
    [pdf_file]='RW_high_mass_with_c-o.pdf'
    [svg_file]='RW_T-mu_plane.svg'
)
declare -rgA RW_very_high_mass=(
    [title]='$\mu_I$ phase diagram at very high masses'
    [caption]="$(Refer_To_Figure '' '2.9(h)' '' '')"
    [pdf_file]='RW_very_high_mass.pdf'
    [svg_file]='RW_T-mu_plane.svg'
)
#------------------------------------------------------------------------------#
update_existing_images='FALSE'
while [[ $# -gt 0 ]]; do
    case $1 in
        -h | --help )
            printf '\n \e[1mSYNOPSIS: %s [option...]\e[0m\n\n' "${BASH_SOURCE[0]}"
            printf '\e[93m%20s\e[0m  ->  \e[96m%s\n'\
                   '-f | --force' 'Update all images, even if existing. If not given, only images'\
                   ''             'with either thumbnail or full resolution image missing are produced.'
            exit 0
            ;;
        -f | --force )
            readonly update_existing_images='TRUE'
            shift
            ;;
        *)
            printf '\n\e[91mERROR: Invalid option "%s".\n' $1
            exit 1
            ;;
    esac
done

#------------------------------------------------------------------------------#

function Convert_PDF_to_JPG()
{
    local -r pdf_file="$1" jpg_file="$2"
    pdftoppm -jpeg -r 300 -singlefile "${pdf_file}" "${jpg_file}"
}

function Create_Image_Thumbnail_And_Full()
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

function Get_List_Of_Image_Authors()
{
    if [[ ! -f "${authors_file}" ]]; then
        printf "\e[91m Authors file not found, unexpeced -> Aborting!\e[0m\n"
        exit 1
    fi
    printf '[%s]' "$(yq -o csv '."'"$1"'".authors' "${authors_file}")"
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
        if [[ "${array_ref[svg_file]}" != '""' ]]; then
            printf "authors: %s\n" "$(Get_List_Of_Image_Authors "${array_ref[svg_file]}")" 
        else
            # If no SVG file, then use pdf file as entry, which we ASSUME to be there
            printf "authors: %s\n" "$(Get_List_Of_Image_Authors "${array_ref[pdf_file]}")"
        fi
        printf '%s\n' '---'
    } > "${images_metadata_folder_path}/${output_number}.md"
}

# Since the webpage is on an orphan branch and the PDF files on main, we'd need
# to switch branch. However, if we then simply put files in the correct folders,
# it would be basically difficult to switch back overwriting existing branches in
# the orphan branch. Hence, we stay on the orphan branch and we get the Pdf folder
# from main, unstage it (checkout automatically stages) and then work and delete
# it. The same is done for other auxiliary needed files.
git checkout main -- Pdf "${authors_file}"
git restore -S Pdf "${authors_file}"

counter=1
updated=1
readonly number_of_images=${#images[@]}
readonly number_of_digits=${#number_of_images}
printf '\n\n'
for image in "${images[@]}"; do
    if ! declare -p "${image}" &>/dev/null; then
        printf "\e[93mWARNING: Metadata '${image}' not found, skipping image!\e[0m\n"
        continue
    fi
    declare -n array_ref=${image}
    number=$(printf '%0*d' ${number_of_digits} ${counter})
    printf "\n\n\e[3A\r\e[92mINFO: Image %s/%d will be added to gallery$(tput sc)\e[0m -> \e[96m%s\e[0m"\
           "${number}" "${number_of_images}" "${image}"
    if [[ ${update_existing_images} = 'TRUE' ]]\
           || [[ ! -f "${images_full_folder_path}/${number}.jpg" ]]\
           || [[ ! -f "${images_thumb_folder_path}/${number}.jpg" ]]; then
        Create_Image_Thumbnail_And_Full "${array_ref[pdf_file]}" ${number}
        (( updated++ ))
    fi
    Create_Image_Metadata_File ${number}
    printf "$(tput rc)\e[K\e[96m ...done!\e[0m\n"
    (( counter++ ))
done
printf "\e[92mINFO: %d image(s) and %d metadata file(s) updated.\e[0m\n" "$((updated-1))" "$((counter-1))"

# Remove Pdf folder and AUTHORS file
git clean -f -- Pdf "${authors_file}" > /dev/null
