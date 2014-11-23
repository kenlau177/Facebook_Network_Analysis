
library(igraph)

inf = "facebook_stanford//0.edges"

G = read.graph(inf, directed=F)
## Simplify to remove duplications and from-self-to-self loops
G = simplify(G, remove.multiple=T, remove.loops=T)
V(G)$label = seq_along(V(G))

wtc = walktrap.community(G, steps=4)
sizes(wtc)

layout <- layout.fruchterman.reingold(G, niter=500, area=vcount(G)^2.3, 
                                      repulserad=vcount(G)^2.8)
opar <- par()$mar; par(mar=rep(0, 4))
plot(G, layout=layout, vertex.size=log(degree(igraphDat) + 1), 
  mark.groups=by(seq_along(wtc$membership), wtc$membership, invisible))





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


wtc = walktrap.community(G, steps=4)
sizes(wtc)
opar <- par()$mar; par(mar=rep(0, 4))




