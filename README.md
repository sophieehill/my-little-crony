# My Little Crony

This repo contains the data and code for my Shiny App, [My Little Crony](https://sophieehill.shinyapps.io/my-little-crony/), visualizing links between Tory politicians and the private companies being awarded government contracts during the pandemic (even without a tender process).

Please feel free to contact me (sophie DOT eva DOT hill AT gmail DOT com) with any corrections, comments, or suggestions!

## Data
The raw data is contained in two files: `people.csv` identifies individuals and organizations (i.e. the "nodes" of the network) and `connections.csv` identifies the links between individuals and organizations (i.e. the "edges" of the network).

## Code
The script `code.R` adds some attributes to the data to aid visualization, like specifying the icon type, colour, size. The data files are then resaved as `people.RData` and `connections.RData`.

## Shiny app
The file `app.R` contains the Shiny app. It can be run locally on your machine or you can see the final product [here on the web](https://sophieehill.shinyapps.io/my-little-crony/)!
