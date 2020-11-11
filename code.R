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
people$icon.size <- degree_value[match(people$id, names(degree_value))] + 40

sort(betweenness(graph, v=V(graph), directed=FALSE))

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
people$font.size <- people$icon.size/2


# connections$label <- connections$type
connections$title <- paste0("<p>", connections$detail, "</p>")
# color edges according to type
connections <- connections %>% mutate(color = case_when(type=="contract" ~ "#f77272",
                                                        type=="donor" ~ "#76a6e8",
                                                        TRUE ~ "#dbd9db"))
connections$value <- ifelse(is.na(connections$contract_size), 5, connections$contract_size)
# make sure "value" is saved as an integer variable
connections$value <- as.integer(as.character(connections$value))

# save datasets to call in Shiny
save(people, file = "people.RData")
save(connections, file = "connections.RData")

# subgraph: just donors and contracts
connections2 <- connections %>% filter(type=="donor" | type=="contract")
connections.ids <- cbind(connections2$to, connections2$from)
people.id2 <- people$id %in% connections.ids
people2 <- people[people.id2,]
drop.list <- c("Michael Gove", "Kate Bingham", "Alpha Solway", "Scottish government",
               "Unknown donors", "UK 2020", "David Cameron")
people2 <- people2 %>% filter(!id %in% drop.list)

# subgraph: Wolf/Frayne
names3 <- c("Rachel Wolf", "James Frayne", "Public First",
            "Dominic Cummings", "David Cameron", "Michael Gove")
connections3 <- connections %>% filter(from %in% names3 | to %in% names3)
connections.ids <- cbind(connections3$to, connections3$from)
people3 <- people[(people$id %in% connections.ids),]
drop.list <- c("Policy Exchange", "Humphry Wakefield", "Babylon Health",
               "Mary Wakefield", "David Meller", "Dido Harding",
               "Jayroma", "Andrew Feldman")
people3 <- people3 %>% filter(!id %in% drop.list)

# subgraph: tax havens
names4 <- c("Mauritius", "Ayanda Capital", "British Virgin Islands",
            "Purple Surgical", "Win Billion Investment Group")
connections4 <- connections %>% filter(from %in% names4 | to %in% names4)
connections.ids <- cbind(connections4$to, connections4$from)
people4 <- people[(people$id %in% connections.ids),]
drop.list <- c("Andrew Mills")
people4 <- people4 %>% filter(!id %in% drop.list)


# preview
visNetwork(people4, connections4) %>%
  visEdges(scaling=list(min=4, max=40)) %>%
  visNodes(scaling=list(min=30)) %>%
  visOptions(highlightNearest = list(enabled = T, degree = 1, hover = T)) %>%
  visInteraction(hover=TRUE, zoomView = TRUE,
                 multiselect=TRUE,
                 navigationButtons = FALSE,
                 tooltipStyle = 'position: fixed;visibility:hidden;padding: 5px;
                font-family: sans-serif;font-size:14px;font-color:#000000;background-color: #e3fafa;
                -moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;
                 border: 0px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);
                 max-width:200px;overflow-wrap: normal') %>%
  visPhysics(solver = "forceAtlas2Based", forceAtlas2Based = list(gravitationalConstant = -80)) %>%
  addFontAwesome() %>%
  visLayout(randomSeed = 02143) %>% visSave("temp.html")


