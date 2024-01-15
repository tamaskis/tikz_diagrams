#!/bin/bash

# Define the file name
file_name="tikz_diagrams"

# Define the .tex file
file_tex="$file_name.tex"

# Define the PDF file
file_pdf="$file_name.pdf"

# Check if PDF file exists and delete if it does
if [ -f "$file_pdf" ]; then
    rm "$file_pdf"
    echo "Existing $file_pdf deleted."
fi

# Perform a clean build of all diagrams
if [ "$#" -eq 1 ] && [ "$1" = "--clean" ]; then

    # Run clear_outputs.sh to clear existing outputs
    ./clear_outputs.sh

    # Run export_diagrams.sh to export all diagrams
    ./export_diagrams.sh

fi

# Define the PDF output directory
pdf_output_dir="pdf_outputs"

# Find all subdirectories in pdf_outputs
subfolders=$(find "$pdf_output_dir" -mindepth 1 -type d | sort)

# Create the .tex file
echo -n > "$file_tex"

# Add preamble to .tex file
cat <<EOL >> "$file_tex"
\documentclass{article}
\usepackage{graphicx}
\usepackage[hidelinks]{hyperref}
\usepackage{titlesec}
\usepackage{courier}
\usepackage[margin=1.5cm]{geometry}
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}
\titleformat{\subsection}{\bfseries\filcenter}{\thesubsection}{1em}{}
\begin{document}
\title{Ti\textit{k}Z Diagrams}
\author{Tamas Kis}
\date{\today}
\maketitle
\tableofcontents
\newpage
EOL

# Loop through each subfolder
for subfolder in $subfolders; do

    # Get the section name (subfolder name)
    section_name=$(basename "$subfolder")

    # Replace underscores with a non-math version and uses typewriter font
    section_name=$(echo "$section_name" | sed 's/_/\\_/g' | sed 's/.*/\\texttt{&}/')
    echo "\\section{$section_name}" >> "$file_tex"

    # Find all PDF files in the subfolder
    pdf_files=$(find "$subfolder" -name "*.pdf" | sort)

    # Loop through each PDF file in the subfolder and add a subsection to .tex file
    for pdf_file in $pdf_files; do
    
        # Get the subsection name (PDF file name)
        subsection_name=$(basename "${pdf_file%.*}")

        # Replace underscores with a non-math version and uses typewriter font
        subsection_name=$(echo "$subsection_name" | sed 's/_/\\_/g' | sed 's/.*/\\texttt{&}/')

        # Adds subsection to .tex file
        echo "\\subsection{$subsection_name}" >> "$file_tex"
        echo "\\vspace{2cm}" >> "$file_tex"
        echo "\\begin{center}" >> "$file_tex"
        echo "\\includegraphics{$pdf_file}" >> "$file_tex"
        echo "\\end{center}" >> "$file_tex"

        # Add more space at the end of each subsection
        echo "\\vspace{2cm}" >> "$file_tex"

    done

done

# Add postamble to .tex file
echo "\end{document}" >> "$file_tex"

# Run pdflatex twice on .tex file (2nd pass required to generate all cross-references for TOC)
pdflatex "$file_tex" >/dev/null 2>&1
pdflatex "$file_tex" >/dev/null 2>&1

# Clean up auxiliary files and tex.file
rm -f "${file_tex%.tex}.aux" "${file_tex%.tex}.log" "${file_tex%.tex}.out" "${file_tex%.tex}.toc" "$file_tex"

# Print completion message
echo "$file_pdf generated successfully!"
