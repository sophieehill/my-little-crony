#SCRAPS
# making a few subgraphs
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