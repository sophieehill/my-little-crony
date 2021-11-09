# set working directory

library(tidyverse)
library(visNetwork)
library(igraph)
library(fontawesome)

# load network data
# (make sure to save csv's as CSV UTF8 to avoid encoding errors)
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


# add photos
photo_list <- c("Conservative party", "UK government",
                "Boris Johnson", "David Cameron",
                "Dominic Cummings", "Matt Hancock",
                "James Bethell", "Andrew Feldman",
                "Owen Paterson")
people <- people %>% mutate(shape = case_when(id %in% photo_list ~ "circularImage",
                                              TRUE ~ "icon"),
                            image = case_when(id %in% photo_list ~ paste0("https://raw.githubusercontent.com/sophieehill/my-little-crony/main/photos/compressed/", gsub(" ", "_", id), ".png"),
                                              TRUE ~ NA_character_),
                            size = case_when(id %in% photo_list ~ as.integer(60),
                                             TRUE ~ icon.size))


# add attributes
people$label <- people$id
people <- people %>% mutate(icon.color = case_when(type=="person" ~ "lightblue",
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
                                              type=="NHS" ~ "#000080",
                                              type=="horse" ~ "brown"),
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
                                              type=="NHS" ~ "f0f8",
                                              type=="horse" ~ "f091"),
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


