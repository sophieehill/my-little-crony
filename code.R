# set working directory

library(tidyverse)
library(visNetwork)
library(igraph)

# load network data
people <- read_csv("people.csv")
connections <- read_csv("connections.csv")


# calculate betweeness in order to scale nodes
graph <- igraph::graph.data.frame(connections, directed = F)
degree_value <- degree(graph, mode = "in")
people$icon.size <- degree_value[match(people$id, names(degree_value))] + 40


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
                                              type=="news" ~ "grey"),
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
                                              type=="news" ~ "f1ea"),
                            icon.face = "FontAwesome",
                            icon.weight = "bold")
people$title <- paste0("<p>", people$desc,"</p>")


# connections$label <- connections$type
connections$title <- paste0("<p>", connections$detail, "</p>")
# connections$color <- ifelse(connections$type=="contract", "#f77272", "#dbd9db")
# connections$color <- "#dbd9db"
# color edges according to type
connections <- connections %>% mutate(color = case_when(type=="contract" ~ "#f77272",
                                                        type=="donor" ~ "#76a6e8",
                                                        TRUE ~ "#dbd9db"))
connections$value <- ifelse(is.na(connections$contract_size), 5, connections$contract_size)

# save datasets to call in Shiny
save(people, file = "people.RData")
save(connections, file = "connections.RData")

# make graph
visNetwork(nodes=people, edges=connections, width = "100%") %>% 
  visEdges(scaling=list(min=4, max=40)) %>%
  visNodes(scaling=list(min=40, max=50)) %>%
  visOptions(highlightNearest = list(enabled = T, degree = 2, hover = T)) %>%
  visInteraction(hover=TRUE, zoomView = TRUE) %>%
  visPhysics(solver = "forceAtlas2Based", forceAtlas2Based = list(gravitationalConstant = -50)) %>%
  addFontAwesome() %>%
visLayout(randomSeed = 12) # to have always the same network  


