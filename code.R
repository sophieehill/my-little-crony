# set working directory

library(tidyverse)
library(visNetwork)
library(igraph)

# load network data
people <- read_csv("people.csv")
connections <- read_csv("connections.csv")

# sort people alphabetically so that the selection list is easier to follow
people <- people[order(people$id),]

# calculate degree cenrality in order to scale nodes
graph <- igraph::graph.data.frame(connections, directed = F)
degree_value <- degree(graph, mode = "in")
sort(degree_value)
# scaling factor 
people$icon.size <- degree_value[match(people$id, names(degree_value))] + 25
big.icons <- c("UK government", "Conservative party")
people$icon.size <- ifelse(people$id %in% big.icons, 50, people$icon.size)
people$icon.size <- as.integer(people$icon.size)


# add attributes
people$label <- people$id
people <- people %>% mutate(shape = "icon",
                            icon.color = case_when(type=="person" ~ "lightblue",
                                              type=="firm" ~ "#7b889c",
                                              type=="political party" ~ "#3377d6",
                                              type=="government" ~ "#3377d6",
                                              type=="political campaign" ~ "#ade0b9",
                                              type=="charity" ~ "#d48ed1",
                                              type=="unknown" ~ "black",
                                              type=="think tank" ~ "purple", 
                                              type=="group" ~ "black",
                                              type=="tax haven" ~ "#489749",
                                              type=="church" ~ "brown",
                                              type=="news" ~ "grey",
                                              type=="NHS" ~ "#000080"),
                            icon.code = case_when(type=="person" ~ "f007",
                                              type=="firm" ~ "f1ad",
                                              type=="political party" ~ "f0c0",
                                              type=="government" ~ "f19c",
                                              type=="political campaign" ~ "f0a1",
                                              type=="charity" ~ "f06b",
                                              type=="unknown" ~ "f21b",
                                              type=="think tank" ~ "f080",
                                              type=="group" ~ "f0c0",
                                              type=="tax haven" ~ "f155",
                                              type=="church" ~ "f02d",
                                              type=="news" ~ "f1ea",
                                              type=="NHS" ~ "f0f8"),
                            icon.face = "FontAwesome",
                            icon.weight = "bold")
people$title <- paste0("<p>", people$desc,"</p>")
people$font.size <- people$icon.size/2

# connections$label <- connections$type
connections$title <- paste0("<p>", connections$detail, "</p>")
# color edges according to type
connections <- connections %>% mutate(color.color = case_when(type=="contract" ~ "#fc9a9a",
                                                        type=="donor" ~ "#95bbf0",
                                                        TRUE ~ "#dbd9db"))
connections$color.highlight <- "yellow"
connections$color.hover <- "yellow"
connections$value <- ifelse(is.na(connections$contract_size), 5, connections$contract_size)
# make sure "value" is saved as an integer variable
connections$value <- as.integer(as.character(connections$value))

# save datasets to call in Shiny
save(people, file = "people.RData")
save(connections, file = "connections.RData")

visNetwork(people, connections) %>%
  visEdges(scaling=list(min=8, max=50)) %>%
  visNodes(scaling=list(min=50, max=500)) %>%
  visOptions(highlightNearest = list(enabled = T, degree = 1, hover = T)) %>%
  visInteraction(hover=TRUE, zoomView = TRUE,
                 multiselect=TRUE,
                 navigationButtons = FALSE,
                 tooltipStyle = 'position: fixed;visibility:hidden;padding: 5px;
                font-family: sans-serif;font-size:14px;font-color:#000000;background-color: #e3fafa;
                -moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;
                 border: 0px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);
                 max-width:200px;overflow-wrap: normal') %>%
  visPhysics(solver = "forceAtlas2Based", forceAtlas2Based = list(gravitationalConstant = -30)) %>%
  addFontAwesome() %>%
  visLayout(randomSeed = 02143)


