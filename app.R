library(shiny)
library(visNetwork)
library(tidyverse)
library(metathis)


server <- function(input, output) {
    output$network <- renderVisNetwork({
        load("people.RData")
        load("connections.RData")
        

        visNetwork(people, connections, width = "160%", height = "150%") %>%
           #  visIgraphLayout() %>%
            visEdges(scaling=list(min=4, max=40)) %>%
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
            visLayout(randomSeed = 02143)
    })
}

ui <- fluidPage(
    # metadata for social sharing
    meta() %>%
        meta_social(
            title = "My Little Crony",
            description = "An interactive visualization of Tory cronyism during the pandemic",
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
        h4("Guide"),
        tags$ul(
            tags$li(em("Scroll")," to zoom"), 
            tags$li(em("Drag")," to move around"),
            tags$li(em("Hover"),"or ", em("tap"), "icons and connections for more info"), 
            style = "font-size:15px;"), 
        p("The lines represent:", style="font-size:15px"),
        p(HTML("&horbar;"), "government contracts", style="color:#f77272;font-size:15px"),
        p(HTML("&horbar;"), "political donations", style="color:#76a6e8;font-size:15px"),
        p(HTML("&horbar;"), "other connections (e.g. family, employer)", style="color:grey;font-size:15px"),
        br(),
        p("Thicker lines indicate more valuable contracts or donations.", style = "font-size:15px;"),
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


