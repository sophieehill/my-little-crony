library(shiny)
library(visNetwork)
library(tidyverse)
library(metathis)


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
            visOptions(highlightNearest = list(enabled = T, degree = 1, hover = T)) %>%
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
    # metadata for social sharing
    meta() %>%
        meta_social(
            title = "metathis",
            description = "<meta> and social media cards for web things in R",
            url = "https://sophieehill.shinyapps.io/my-little-crony/",
            image = "https://www.sophie-e-hill.com/img/crony_preview.png",
            image_alt = "An image for social media cards",
            twitter_creator = "@sophie_e_hill",
            twitter_card_type = "summary",
            twitter_site = "@sophie_e_hill"
        ),
    
    titlePanel("My Little Crony"),
    verticalLayout(p("A visualization of the connections between", strong("Tory politicians"), "and", strong("companies being awarded government contracts during the pandemic,"), "based on reporting by", a(href="https://www.opendemocracy.net/en/dark-money-investigations/", "openDemocracy,"), a(href="https://bylinetimes.com/", "Byline Times,"), "and more.",
                   style = "font-size:20px;")),
    sidebarLayout(
        sidebarPanel(
        h4("Navigation"), br(),
        tags$ul(
            tags$li(em("Scroll")," to zoom"), br(),
            tags$li(em("Drag")," to move around"), br(),
            tags$li(em("Hover")," on icons and connections for more info"), 
            style = "font-size:15px;"),
        hr(),
        p("Created by", a(href="https://sophie-e-hill.com/", "Sophie E. Hill"),
          HTML("&bull;"),
         "Code on", a(href="https://github.com/sophieehill/my-little-crony", "Github"),
         HTML("&bull;"), 
          "Follow me on",
          a(href="https://twitter.com/sophie_e_hill", "Twitter"),
          style="font-size:15px;"), 
        width=3),
        mainPanel(
        visNetworkOutput("network", height="80vh", width="100%"), width=9
    )
)
)

shinyApp(ui = ui, server = server)


