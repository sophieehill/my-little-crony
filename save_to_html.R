# library("visNetwork")
# load("people.RData")
# load("connections.RData")

visNetwork(people, connections, width = "1000px", height = "580px",
           main=list(text="My Little Crony",
                     style='font-family:Source Sans Pro, Helvetica, sans-serif;font-weight:bold;font-size:22px;text-align:left;'),
           submain=list(text="(It may take a few moments to load) \n",
                        style='font-family:Source Sans Pro, Helvetica, sans-serif;font-style:italic;font-size:14px;text-align:left;')) %>%
  visEdges(scaling=list(min=8, max=40), smooth=FALSE) %>%
  visNodes(scaling=list(min=100, max=100), 
           shapeProperties = list(useImageSize=FALSE, 
                                  interpolation=FALSE)) %>%
  visOptions(highlightNearest = list(enabled = T, degree = 1, 
                                     hover = T, 
                                     hideColor = 'rgba(200,200,200,0.2)',
                                     labelOnly=FALSE),
             nodesIdSelection=TRUE) %>%
  visInteraction(hover=TRUE, zoomView = TRUE,
                 navigationButtons = TRUE,
                 tooltipStyle = 'position: fixed;visibility:hidden;padding: 5px;
                font-family: sans-serif;font-size:12px;
                font-color:#000000;background-color: #e3fafa;
                -moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;
                 border: 0px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.5);
                 max-width:200px;overflow-wrap: normal') %>%
  visPhysics(solver = "forceAtlas2Based", 
             maxVelocity = 1000,
             minVelocity = 5,
             forceAtlas2Based = list(gravitationalConstant = -150),
             stabilization = FALSE) %>%
  addFontAwesome() %>%
  visLayout(randomSeed = 02143, improvedLayout=TRUE) %>%
  htmlwidgets::appendContent(htmltools::includeHTML("meta.html")) %>%
  visSave(file = "crony.html")

