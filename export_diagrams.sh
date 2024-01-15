#!/bin/bash

# Default values of command line arguments
eps=false
folder=""
file=""

# Flags to check if --folder or --file is specified
folder_specified=false
file_specified=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --eps) eps=true ;;
    --folder)
      folder="${2-}"
      folder_specified=true
      ;;
    --file)
      file="${2-}"
      file_specified=true
      ;;
  esac
  shift
done

# Check if both --folder and --file are specified
if [[ "$folder_specified" = true && "$file_specified" = true ]]; then
  echo "Error: Cannot specify both --folder and --file at the same time."
  exit 1
fi

# Define the output directories
pdf_output_dir="pdf_outputs"
eps_output_dir="eps_outputs"

# Create the PDF output directory if it doesn't exist
mkdir -p "$pdf_output_dir"

# Create the EPS output directory if it doesn't exist and if the --eps flag is provided
if [[ "$eps" = true ]]; then
    mkdir -p "$eps_output_dir"
fi

# Subroutine to export PDF and EPS
export_diagrams() {

    # Local variable storing tex file
    local tex_file="$1"

    # Print the name of the file being exported
    echo "Exporting: $tex_file"

    # Extract the directory of the .tex file
    dir=$(dirname "$tex_file")

    # Change to the directory of the .tex file
    cd "$dir" || exit
    
    # Remove "src" from front of path
    dir=${dir#./src/}   # needed when calling ./export_diagrams.sh
    dir=${dir#src/}     # needed when calling ./export_diagrams.sh with --file or --folder options

    # Run pdflatex --shell-escape on the .tex file to generate the PDF image
    pdflatex --shell-escape -interaction nonstopmode "$(basename "$tex_file")" > pdflatex_error.log 2>&1
    pdflatex_status=$?

    # Check if pdflatex encountered an error
    if [[ $pdflatex_status -ne 0 ]]; then
        cat pdflatex_error.log
        echo "Error during pdflatex. Check $tex_file for details."
        rm -f pdflatex_error.log
        exit 1
    else
        rm -f pdflatex_error.log
    fi

    # Extract the base name without extension
    base_name=$(basename "${tex_file%.tex}")

    # Replicate the folder structure in the PDF output directory
    mkdir -p "../../$pdf_output_dir/$dir"

    # Move the generated PDF to the PDF output directory
    mv "$base_name-figure0.pdf" "../../$pdf_output_dir/$dir/$base_name.pdf"

    # Convert PDF to EPS if --eps flag is provided
    if [[ "$eps" = true ]]; then

        # Replicate the folder structure in the EPS output directory
        mkdir -p "../../$eps_output_dir/$dir"

        # Run pdftops to convert the PDF file to an EPS file
        pdftops "../../$pdf_output_dir/$dir/$base_name.pdf" "../../$eps_output_dir/$dir/$base_name.eps" > pdftops_error.log 2>&1
        pdftops_status=$?

        # Check if pdftops encountered an error
        if [[ $pdftops_status -ne 0 ]]; then
            cat pdftops_error.log
            echo "Error during pdftops. Check $tex_file for details."
            rm -f pdftops_error.log
            exit 1
        else
            rm -f pdftops_error.log
        fi
    fi

    # Delete additional generated files
    rm -f "$base_name-figure0.dpth" \
          "$base_name-figure0.log" \
          "$base_name-figure0.md5" \
          "$base_name.aux" \
          "$base_name.auxlock" \
          "$base_name.log" \
          "$base_name.pdf" \
          "texput.log"

    # Return to the original directory
    cd - > /dev/null || exit
}

# Process a single file if --file is provided
if [[ -n "$file" ]]; then
    export_diagrams "src/$file"

# Process multiple files
else

    # Find all .tex files in the specified folder or all folders if not specified
    if [[ -n "$folder" ]]; then
        tex_files=$(find "src/$folder" -name "*.tex")
    else
        tex_files=$(find . -name "*.tex")
    fi

    # Loop through each .tex file and call the export subroutine
    for tex_file in $tex_files; do
        export_diagrams "$tex_file"
    done

fi

# Define the directory containing images used to create some diagrams
images_dir="src/.images"

# Find all converted PDF files in the .images/ directory
converted_eps_images=$(find "$images_dir" -name "*-eps-converted-to.pdf" | sort)

# Loop through each converted EPS image in the .images/ directory and delete it
for converted_eps_image in $converted_eps_images; do
    rm "$converted_eps_image"
done