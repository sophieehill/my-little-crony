library(shiny)
library(visNetwork)
library(tidyverse)
library(metathis)

server <- function(input, output) {
    NULL
}

ui <- fluidPage(
    # Google analytics script
    
    titlePanel("My Little Crony"),
    verticalLayout(p("The latest version of My Little Crony is available at", a(href="https://www.mylittlecrony.com", "www.mylittlecrony.com"), style = "font-size:20px;")),
 
)


shinyApp(ui = ui, server = server)


