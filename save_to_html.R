library("visNetwork")

load("people.RData")
load("connections.RData")

visNetwork(people, connections, width = "600px", height = "500px") %>%
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
  visLayout(randomSeed = 02143) %>%
  visSave(file = "crony.html")