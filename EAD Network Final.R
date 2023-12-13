## EAD Network Analysis
## November 7th, 2023
## Chelsea Tao & Tyler Rudolph, EAD
#############################################

library(igraph)
library(ggraph)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(netUtils)
library(tidygraph)
library(ggrepel)
library(snahelper)
library(scales)

options(max.overlaps=Inf)

## Set global parameters 

globparms <- list(wd=getwd(),
                  rawDir= "C:/Users/ctao/Documents/EAD/R_Project_Files/Data/raw",
                  scratchDir= "C:/Users/ctao/Documents/EAD/R_Project_Files/Data/raw/temp",
                  outputDir = "C:/Users/ctao/Documents/EAD/R_Project_Files/Data/output")

## Import CSV data for nodes & edges (located on local machine)
## Specify columns (variables)

nodes <- read.csv(file.path(globparms$rawDir, "EAD Network Names.csv")) [,1:3]
edges <- read.csv(file.path(globparms$rawDir, "EAD Network Edgelist.csv"))[,1:2]
names <- nodes$Name

## Create graph from data frame

EAD_Network <- graph_from_data_frame(d = edges,
                              vertices = nodes,
                              directed = TRUE)


## Weighting nodes & edges

V(EAD_Network)$interactions <- betweenness(EAD_Network,
                                           v=V(EAD_Network),
                                           directed=FALSE,
                                           weights=NULL,
                                           normalized=FALSE)

# V(EAD_Network)$interactions <- alpha_centrality(EAD_Network,
#                                                 nodes = V(EAD_Network),
#                                                 alpha = 1,
#                                                 loops = TRUE)


# V(EAD_Network)$interactions <- strength(EAD_Network,
#                                            vids=V(EAD_Network),
#                                            mode = c("total"),
#                                            loops = TRUE)

E(EAD_Network)$weight <- edge_betweenness(EAD_Network,
                                          e = E(EAD_Network),
                                          directed = FALSE,
                                          weights = NULL,
                                          cutoff = "-1")

weight_scaled <- scales::rescale(E(EAD_Network)$weight, to = 0,1)

## Visualize network (ggraph)

EAD_plot <- ggraph(graph = EAD_Network, layout = "fr") +
  geom_edge_link0(edge_colour="grey25",
                  aes(edge_width= weight)) +
  geom_node_point(shape=21, color="black",stroke=1,
                  aes(fill=Team, size=interactions)) + ## Node color filled by team, size depends on the number of interactions of each node. Can change "fill" to "shape" to assign unique shape for each team.
  geom_node_label(aes(label=name),color="black", repel=TRUE) +
  scale_edge_width(range=c(0.1,2.0), 
                   guide="none") +
  scale_edge_colour_gradient(low="white",high="black",
                             guide = "edge_colourbar",
                             aesthetics = "edge_colour") + 
  scale_size(range=c(6.5,25), guide="none") +
  scale_fill_manual(values=c("red","blue","orange","purple","yellow","green","pink"), na.value="grey", name="") +
  theme(legend.position="bottom") +
  ggtitle("CFS-EAD Network",
          subtitle="Updated 12/11/23")

EAD_plot 

# dendrogram <- as.dendrogram(hclust(dist(iris[, 1:5])))
# EAD_Dendrogram <- ggraph(EAD_Network, 'dendrogram') + 
#   geom_edge_elbow() +
#   geom_node_point(shape=21,color="black",stroke=0.5,
#                   aes(fill=Team, size=interactions)) +
#   # geom_node_label(aes(label=name),color="black", repel=TRUE) +
#   geom_node_text(color="black", size=4, repel=TRUE,
#                  aes(label=names)) +
#   scale_size(range=c(3,20), guide="none") +
#   scale_fill_manual(values=c("red","blue","orange","purple","yellow","green","pink"), na.value="grey", name="") +
#   theme(legend.position="bottom")
# 
# EAD_Dendrogram

ggsave("EAD_Network_Plot.jpg",
       plot=EAD_plot,
       width=12,
       height=9.5,
       units=c("in"))


## Testing descriptive stats
distances(EAD_Network)[1:25, 1:25] ## Degrees of separation
shortest_paths(EAD_Network, from="Chelsea Tao", to="Sydney Rowe") ## Goes through Greg? 
diameter(EAD_Network) ## Length of the longest shortest path 
