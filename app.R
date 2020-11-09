library(shiny)
library(visNetwork)
library(tidyverse)

# clean data
source("code.R")

server <- function(input, output) {
    output$network <- renderVisNetwork({
        load("people.RData")
        load("connections.RData")
        
        # create legend for nodes
        people.unique <- people %>% 
            select(type, shape, icon.color, icon.code) %>% 
            unique()
        legend.nodes <- data.frame(label = people.unique$type, 
                   shape = "icon",
                   icon.code = people.unique$icon.code, 
                   icon.size = 10, 
                   icon.color = people.unique$icon.color)
        

        visNetwork(people, connections, width = "160%", height = "150%") %>%
           #  visIgraphLayout() %>%
            visEdges(width=5) %>%
            visNodes(scaling=list(min=30)) %>%
            visOptions(highlightNearest = list(enabled = T, degree = 2, hover = T)) %>%
            visInteraction(hover=TRUE, zoomView = TRUE,
                           navigationButtons = TRUE,
                           tooltipStyle = 'position: fixed;visibility:hidden;padding: 5px;
                font-family: sans-serif;font-size:14px;font-color:#000000;background-color: #e3fafa;
                -moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;
                 border: 0px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);
                 max-width:200px;overflow-wrap: normal') %>%
            visPhysics(solver = "forceAtlas2Based", forceAtlas2Based = list(gravitationalConstant = -50)) %>%
            addFontAwesome() %>%
           #  visLegend(addNodes=legend.nodes) %>%
            visLayout(randomSeed = 12)
    })
}

ui <- fluidPage(
    titlePanel("My Little Crony"),
    verticalLayout(
        p("A visualization of the connections between", strong("Tory politicians"), "and", strong("companies being awarded government contracts during the pandemic,"), "based on reporting by", a(href="https://www.opendemocracy.net/en/dark-money-investigations/", "openDemocracy,"), a(href="https://bylinetimes.com/", "Byline Times,"), "and more."),
        p(em("Scroll up/down to zoom in/out, drag to move around. Hover on icons and connections for more info.")),
        visNetworkOutput("network", height="80vh", width="100%"),
        p("Created by", a(href="https://sophie-e-hill.com/", "Sophie E. Hill"), "(", a(href="https://twitter.com/sophie_e_hill", "@sophie_e_hill"), "). The data and code for this app are publicly available on", a(href="https://github.com/sophieehill/my-little-crony", "Github."),"Please", a(href="https://www.sophie-e-hill.com/#contact", "contact me"), "with any corrections, comments, or suggestions!")
    )
    )

shinyApp(ui = ui, server = server)


