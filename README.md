# Ti*k*Z Diagrams

## Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Project organization](#project-organization)
4. [Exporting diagrams as PDF and EPS files](#exporting-diagrams-as-pdf-and-eps-files)
5. [Creating a single document with all generated diagrams](#creating-a-single-document-with-all-generated-diagrams)
6. [Clearing outputs](#clearing-outputs)
7. [Creating your own Ti*k*Z diagrams](#creating-your-own-tikz-diagrams)
    1. [Document template](#document-template)
    2. [Using color themes](#using-color-themes)
    3. [Additional features beyond "vanilla" Ti*k*Z](#additional-features-beyond-vanilla-tikz)
    4. [Additional resources](#additional-resources)

## Overview

This project has two main goals:
1. **Make it easier for new users of Ti*k*Z to create diagrams.** Creating diagrams for LaTeX using Ti*k*Z can be challenging, and often the easiest way to learn it is to build off of what others have done. This project is an organization of all the Ti*k*Z diagrams I have created throughout the years. The source code for producing the diagrams contains many comments for what each bit of the code is doing.
2. **Provide an easy way to export PDF and EPS files of diagrams so they don't have to be recompiled in larger documents.** Complicated Ti*k*Z diagrams can severely affect compilation times, so it is often better (especially for larger documents) to include them as PDF files (although you should note that this may increase the file size of your document). Included in this project is a simple script (`export_diagrams.sh`) that traverses the `src/` folder of this project and exports all Ti*k*Z diagrams to PDF and (if specified) EPS files. See the section titled [_Exporting diagrams as PDF and EPS files_](#exporting-diagrams-as-pdf-and-eps-files) for more information.

## Installation

### Recommended installations

1. [**TeX Live**](https://www.tug.org/texlive/). This will serve as our LaTeX compiler.
    - For macOS, I am using the [MacTeX distribution](https://www.tug.org/mactex/mactex-download.html).
    - Once the installation is complete, close any terminal windows you have open and open a new terminal. This should ensure that the LaTeX distribution is added to your PATH environment variable (should be done automatically). This will be relevant when building a document using the [LaTeX Workshop VS Code extension](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) (see step 6 of the [Setup](#setup) section below).
    - If the above step does not work, restart your computer and try again.
2. [**Visual Studio Code (VS Code)**](https://code.visualstudio.com/).
3. [**Git**](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). Cloning the repository + revision control.
4. [**`pdftops`**](https://www.xpdfreader.com/pdftops-man.html). Converting from `pdf` to `eps`.
    - First, check if `pdftops` is already installed (sometimes installed in LaTeX distributions) by running
    
        ```bash
        which pdftops
        ```

        to locate its executable.
    - If `pdftops` is not installed, you can installer it by installing [Poppler](https://poppler.freedesktop.org/). For example, in a terminal on macOS, I performed this installation via

        ```bash
        brew install poppler
        ```

### Setup

1. In a terminal, navigate to a folder in which you would like to clone the `tikz_diagrams` repository.
2. Clone the `tikz_diagrams` repository.

    ```
    git clone https://github.com/tamaskis/tikz_diagrams.git
    ```

3. Open the `tikz_diagrams` project in VS Code.
4. Grant permissions to execute the provided scripts.

    ```bash
    chmod +x export_diagrams.sh
    chmod +x create_doc.sh
    chmod +x clear_outputs.sh
    ```

5. Try executing `create_doc.sh`.

    ```bash
    ./create_doc.sh
    ```

6. If the above step did not work, then the `PATH` environment variable was not set correctly during your installation of a LaTeX distribution. See [this page](https://github.com/James-Yu/LaTeX-Workshop/wiki/Install#setting-path-environment-variable) for more information.

## Project organization

All `.tex` files creating diagrams are contained within the `src/` folder. Within the `src/` folder, they are organized into separate subfolders, each representing different categories.

```
- tikz_diagrams/
  |- .vscode/
  |   |- extensions.json    # recommend extensions
  |   |- settings.json      # configure the project in VS Code
  |- src/
  |   |- .images/
  |   |   |- licenses/              # licenses for third-party images
  |   |   |- IMAGE_SOURCES.md       # lists sources for each image
  |   |   |- image_creation.pptx    # PowerPoint document used to create some custom images
  |   |   |- image_1.eps
  |   |   |- image_2.png
  |   |   |- ...
  |   |- .preamble/
  |   |   |- third_party/               # third-party TikZ tools that need to be manually added to a project
  |   |   |- tikz_diagrams_template.sty # style template used by all .tex files defining TikZ diagrams
  |   |- subfolder_1/
  |   |   |- diagram_1.tex
  |   |   |- diagram_2.tex
  |   |   |- ...
  |   |- subfolder_2/
  |   |   |- diagram_3.tex
  |   |   |- diagram_4.tex
  |   |   |- ...
  |   |- ...
  |- clear_outputs.sh       # script that deletes the `pdf_outputs/` and `eps_outputs/` folders.
  |- create_doc.sh          # script that creates the tikz_diagrams.pdf file
  |- export_diagrams.sh     # script that exports diagrams to PDF and EPS 
  |- README.md              # this file
  |- tikz_diagrams.pdf      # all TikZ diagrams defined in this project compiled into a single PDF diagrams
```

## Exporting diagrams as PDF and EPS files

### Syntax

```bash
./export_diagrams.sh                                # exports all diagrams in all folders to PDF files
./export_diagrams.sh --eps                          # exports all diagrams to both PDF and EPS files
./export_diagrams.sh --folder my_folder             # exports all diagrams in my_folder to PDF files
./export_diagrams.sh --folder my_folder --eps       # exports all diagrams in my_folder to both PDF and EPS files
./export_diagrams.sh --file my_folder/my_file       # exports diagram in my_file to a PDF file
./export_diagrams.sh --file my_folder/my_file --eps # exports diagram in my_file to both a PDF and an EPS file
```

### Output locations

- All PDF files are output to `pdf_outputs`.
- All EPS files are output to `eps_outputs`.

### Examples

1. To generate all diagrams as PDF files, run

    ```bash
    ./export_diagrams.sh
    ```

    The PDF files will be saved to `pdf_outputs/`.

2. To also generate all diagrams as EPS files, run

    ```bash
    ./export_diagrams.sh --eps
    ```

    Like before, the PDF files will be saved to `pdf_outputs/`, while this time we also save EPS files to `eps_outputs/`.

3. To export only the diagrams in `src/astrodynamics/`,

    ```bash
    ./export_diagrams.sh --folder astrodynamics
    ```

    To also export them as EPS files,

    ```bash
    ./export_diagrams.sh --folder astrodynamics --eps
    ```

4. To only export the diagram defined by `src/astrodynamics/cylindrical_eclipse_model.tex`,

    ```bash
    ./export_diagrams.sh --file astrodynamics/cylindrical_eclipse_model.tex
    ```

    To also export it as an EPS file,

    ```bash
    ./export_diagrams.sh --file astrodynamics/cylindrical_eclipse_model.tex --eps
    ```

## Creating a single document with all generated diagrams

To compile all Ti*k*Z diagrams defined in the `src/` folder into a single LaTeX document, run the `create_doc.sh` script:

```bash
./create_doc.sh         # compiles all diagrams currently existing in pdf_outputs/ into a single document
./create_doc.sh --clean # rebuilds all diagrams defined in src/ and compiles them into a single document
```

This script

1. Deletes the existing version of `tikz_diagrams.pdf`.
2. Deletes the existing `pdf_outputs/` and `eps_outputs/` folders and regenerates ALL diagrams if the `--clean` option is specified.
3. Combine all PDF diagrams in the `pdf_outputs/` folder into a single, organized PDF document, `tikz_diagrams.pdf`.

## Clearing outputs

To clear all outputs, you can execute the `clear_outputs.sh` bash script.

```bash
./clear_outputs.sh
```

This will delete both the `pdf_outputs/` and `eps_outputs/` folders (if they exist).

## Creating your own Ti*k*Z diagrams

### Document template

```latex
% ---------
% Preamble.
% ---------

% Document type.
\documentclass{article}

% Import custom style.
\usepackage{../.preamble/tikz_diagrams_template}

% Color theme (black, red, blue, green, orange, purple, gold).
\colortheme{blue}

% ---------
% Document.
% ---------

\begin{document}

    % -----------------
    % TikZ environment.
    % -----------------

    \begin{tikzpicture}

        % INSERT YOUR TIKZ CODE HERE

    \end{tikzpicture}

\end{document}
```

### Using color themes

#### Specifying the color theme for a Ti*k*Z diagram

Many of the Ti*k*Z diagrams are set up to compatible with many color "themes". The choice of color theme is specified in each individual `.tex` file in the `src/` folder. For example,

```tex
% Color theme (black, red, blue, green, orange, purple, gold).
\colortheme{blue}
```

The choices for the color theme are:

- `black`
- `red`
- `blue`
- `green`
- `orange`
- `purple`
- `gold`


#### Setting up a new Ti*k*Z diagram with color theme support

To create a new Ti*k*Z diagram that supports the color themes specified above, all you need to do is the following:

1. After any `\usepackage` imports and before `\begin{document}`, include

    ```latex
    \colortheme{insert your color theme choice here}
    ```

1. In the code defining your Ti*k*Z diagram, the following custom colors are available for your use:

    | Color | Description |
    | ----- | ----------- |
    | `color_theme` | the color specified by the \colortheme{} command in step 1 above |
    | `shade_color` | a shaded (i.e. lighter) version of `color_theme` |
    | `verylightgray` | a generic light gray color that is lighter than the built-in `lightgray` |
    
    > These colors are all defined in `src/.preamble/tikz_diagrams_template.sty`.
    
    As an example, we could draw a circle outlined in blue and shaded with a lighter blue by first specifying the color theme using

    ```latex
    \colortheme{blue}
    ```

    and then in the Ti*k*Z environment using

    ```latex
    \draw[color_theme,fill=shade_color](0,0)circle(1);
    ```


### Additional features beyond "vanilla" Ti*k*Z

The template for this project is provided by `src/.preamble/tikz_diagrams_template.sty`. This style template is imported into every `.tex` file in the `src/` folder. This style template includes the following additional features beyond "vanilla" Ti*k*Z:

| Feature | Description/Source | Example |
| :------ | :----------------- | :------ |
| 3D drawing | [`tikz-3dplot`](https://ctan.org/pkg/tikz-3dplot?lang=en) | [`least_squares_derivation_1`](src/numerical_math/least_squares_derivation_1.tex) |
| 3D circles | [`tikz-3dplot-circleofsphere`](https://github.com/matthias-wolff/tikz-3dplot-circleofsphere). Note that this package is not available on CTAN, so it is included directly in this project as `src/.preamble/third_party/tikz-3dplot-circleofsphere.sty` and imported into `src/.preamble/tikz_diagrams_template.sty`. | [`geocentric_right_ascension_and_declination`](src/aerospace/geocentric_right_ascension_and_declination.tex) |
| rotating coordinate systems using 3-2-1 Euler angles (instead of 3-2-3) | `\tdseteulerxyz` command defined in `src/.preamble/tikz_diagrams_template.sty` (see https://tex.stackexchange.com/questions/118069/how-to-draw-an-euler-angle-rotation-sequence-with-tikz) | [`airplane_body_frame`](src/rotations_and_attitude/airplane_body_frame.tex) |
| parameterization and function plotting | [`pgfplots`](https://ctan.org/pkg/pgfplots?lang=en) | [`continuous_function`](src/numerical_math/continuous_function.tex) |
| better arrow(head)s | `mylatex` arrowhead style defined in `src/.preamble/tikz_diagrams_template.sty` (see https://tex.stackexchange.com/questions/51555/changing-arrowheads-size-in-pgfplots-axes) | [`normal_shock`](src/compressible_flow/normal_shock.tex) |
| patterns | TikZ [`patterns` library](https://tikz.dev/library-patterns) | [`coupled_mass_spring_damper_system`](src/system_dynamics/coupled_mass_spring_damper_system.tex) |
| decorations.marking | TikZ [`decorations.marking` sub-library](https://tikz.dev/library-decorations) | [`hohmann_transfer`](src/aerospace/hohmann_transfer.tex) |
| math characters | [`amsmath`](https://ctan.org/pkg/amsmath?lang=en), [`amsfonts`](https://ctan.org/pkg/amsfonts?lang=en), and [`mathdots`](https://ctan.org/pkg/mathdots?lang=en) | [`bivariate_grid`](src/numerical_math/bivariate_grid.tex) |
| other special characters | [`wasysym`](https://ctan.org/pkg/wasysym?lang=en) | [`keplerian_orbital_elements`](src/aerospace/keplerian_orbital_elements.tex) |
| circled characters | `\circled` command defined in `src/.preamble/tikz_diagrams_template.sty` | [`oblique_shock`](src/compressible_flow/oblique_shock.tex) |

### Additional resources

While this project aims to be a more bare-bones approach to building basic Ti*k*Z diagrams, there is a rich ecosystem out there for building more complicated Ti*k*Z diagrams. Check out [**Awesome Ti*k*Z**](https://github.com/xiaohanyu/awesome-tikz) for a fairly comprehensive list of other Ti*k*Z libraries.