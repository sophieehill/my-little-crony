# My Little Crony

This repo contains the data and code for [My Little Crony](https://www.mylittlecrony.com), a visualization of the links between Tory politicians and the companies being awarded government contracts during the pandemic.

Please feel free to contact me (sophie DOT eva DOT hill AT gmail DOT com) or submit a PR with any corrections, comments, or suggestions!

## Data
The raw data is contained in two files: `people.csv` identifies individuals and organizations (i.e. the "nodes" of the network) and `connections.csv` identifies the links between individuals and organizations (i.e. the "edges" of the network).

## Code
The script `code.R` adds some attributes to the data to aid visualization, like specifying the icon type, colour, size. The data files are then resaved as `people.RData` and `connections.RData`.

The script `save_to_html.R` takes the cleaned datasets (`people.RData` and `connections.RData`) and produces the visualization as a standalone HTML file called `crony.html`. This HTML file can be opened and viewed in any web browser.

## Getting started with R

If you are new to R, here is a quick guide to getting started with this repo:
1. [Install R](https://www.r-project.org/)
2. [Install RStudio](https://www.rstudio.com/products/rstudio/download/)
3. Download a local copy of this repo (click on "Code" and then "Download ZIP")
4. Open the project (`my-little-crony.Rproj`) in RStudio
5. Install the required packages ("install.packages(packagename)")
6. Run the code!

## Acknowledgements
This visualization relies on excellent investigative journalism by [Byline Times](https://bylinetimes.com/), [Open Democracy](https://www.opendemocracy.net/en/), [The Citizens](https://the-citizens.com/), and many others! The visualization itself relies on the awesome `[visNetwork](https://datastorm-open.github.io/visNetwork/)` R package.
