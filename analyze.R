
library(igraph)
library(RColorBrewer)
library(plyr)
library(dplyr)

fbNetworkFile = "facebook_with_relation.gml"
# read in the .gml file
G = read.graph(file=fbNetworkFile, format="gml")
# set the size of vertice labels
V(G)$label.cex = .5

pairedColors = c(brewer.pal(n=12, name="Paired"))
names(pairedColors) = c("ultimate-rec", "ultimate-competitive", "ubc-cpsc", 
                        "ubc-stat", "ubc-event", "closest-friends", "soccer", 
                        "hockey", "toys-r-us", "environment-canada", 
                        "high-school", "relative")
V(G)$color = revalue(V(G)$relation, pairedColors)

# optimize space for plotting
opar <- par()$mar; par(mar=rep(0, 4))
#plot(G, layout=layout.fruchterman.reingold(G), vertex.size=5)
layout <- layout.fruchterman.reingold(G, niter=500, area=vcount(G)^2.3, 
            repulserad=vcount(G)^2.8)
plot(G, layout=layout, vertex.size=5)
par(mar=opar)

fc = fastgreedy.community(G)
sizes(fc)
plot(G, layout=layout, vertex.size=5, mark.groups=by(seq_along(fc$membership), 
  fc$membership, invisible))

ebc = edge.betweenness.community(G)
sizes(ebc)
plot(G, layout=layout, vertex.size=5, mark.groups=by(seq_along(ebc$membership), 
 ebc$membership, invisible))

lec = leading.eigenvector.community(G)
sizes(lec)
plot(G, layout=layout, vertex.size=5, mark.groups=by(seq_along(lec$membership), 
 lec$membership, invisible))

wtc = walktrap.community(G, steps=4)
sizes(wtc)
plot(G, layout=layout, vertex.size=5, mark.groups=by(seq_along(wtc$membership), 
 wtc$membership, invisible))


# clustering coefficient of graph
transitivityG = transitivity(G, type="undirected")




