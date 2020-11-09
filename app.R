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
        

        visNetwork(people, connections, width = "100%", height = "100%") %>%
           #  visIgraphLayout() %>%
            visEdges(width=5, color="#dbd9db") %>%
            visNodes(scaling=list(max=80)) %>%
            visOptions(highlightNearest = list(enabled = T, degree = 2, hover = T)) %>%
            visInteraction(hover=TRUE, zoomView = TRUE,
                           tooltipStyle = 'position: fixed;visibility:hidden;padding: 5px;
                font-family: sans-serif;font-size:14px;font-color:#000000;background-color: #e3fafa;
                -moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;
                 border: 0px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);
                 max-width:200px;overflow-wrap: normal') %>%
            visPhysics(solver = "forceAtlas2Based", forceAtlas2Based = list(gravitationalConstant = -30)) %>%
            addFontAwesome() %>%
           #  visLegend(addNodes=legend.nodes) %>%
            visLayout(randomSeed = 12)
    })
}

ui <- fluidPage(
    titlePanel("My Little Crony"),
    verticalLayout(
        p("A visualization of the connections between Tory politicians and private companies that have been awarded government contracts."),
        p(""),
        p("Scroll to zoom, drag to move around. Hover on icons and links for more info."),
        visNetworkOutput("network", height="100vh", width="100%")
    )
    )

shinyApp(ui = ui, server = server)


