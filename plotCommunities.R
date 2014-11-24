
library(igraph)
library(RColorBrewer)
library(plyr)
library(dplyr)
library(xtable)
library(gridExtra)

source("count.degree.distribution.R")
source("computeStats.R")

fbNetworkFile = "facebook_with_relation.gml"
G = read.graph(file=fbNetworkFile, format="gml")

pairedColors = c(brewer.pal(n=12, name="Paired"))
names(pairedColors) = c("ultimate-rec", "ultimate-competitive", "ubc-cpsc", 
                        "ubc-stat", "ubc-event", "closest-friends", "soccer", 
                        "hockey", "toys-r-us", "environment-canada", 
                        "high-school", "relative")
V(G)$color = revalue(V(G)$relation, pairedColors)

erdo = erdos.renyi.game(length(V(G)), p.or.m=length(E(G)), type="gnm")

nameList = c("Yuji Aizawa", "Jasper Lu", "Rhona Yue", "Kevin Underhill",
             "Esther Fann", "Sean Montgomery", "Tyki Sueyoshi", "Louisa Lau",
             "Ellery Lee", "Jonathan Baik", "Alex Tan", "Andrew Brear",
             "Angela S", "Simon Tai")

V(G)$label.cex = 1
labelsG = V(G)$label
labelsG[!(labelsG %in% nameList)] = NA

opar <- par()$mar; par(mar=rep(0, 4))
layout <- layout.fruchterman.reingold(G, niter=500, area=vcount(G)^2.3, 
                                      repulserad=vcount(G)^2.8)
myPlot = plot(G, layout=layout, vertex.size=log(betweenness(G) + 1), 
              vertex.label=labelsG, vertex.label.color="black")
legendLabels = unique(V(G)$relation)
legendColours = unique(V(G)$color)
legend("topleft", legend=legendLabels, col=legendColours, pch=19, 
       bty="n", cex=.8)

mc = fastgreedy.community(G)
mcErdo = fastgreedy.community(erdo)

wtc = walktrap.community(G, steps=4)
wtcErdo = walktrap.community(erdo, steps=4)

png(file="my_ego_mc.png")
opar <- par()$mar; par(mar=rep(0, 4));
plot(G, layout=layout, vertex.size=log(betweenness(G) + 1), 
     vertex.label=labelsG, vertex.label.color="black", 
     mark.groups=by(seq_along(mc$membership), mc$membership, invisible))
legendLabels = unique(V(G)$relation)
legendColours = unique(V(G)$color)
legend("topleft", legend=legendLabels, col=legendColours, pch=19, 
       bty="n", cex=.8)
dev.off()

png(file="my_ego_wtc.png")
opar <- par()$mar; par(mar=rep(0, 4));
plot(G, layout=layout, vertex.size=log(betweenness(G) + 1), 
     vertex.label=labelsG, vertex.label.color="black", 
     mark.groups=by(seq_along(wtc$membership), wtc$membership, invisible))
legendLabels = unique(V(G)$relation)
legendColours = unique(V(G)$color)
legend("topleft", legend=legendLabels, col=legendColours, pch=19, 
       bty="n", cex=.8)
dev.off()

png(file="my_erdo_mc.png")
opar <- par()$mar; par(mar=rep(0, 4));
plot(erdo, layout=layout, vertex.size=log(betweenness(erdo) + 1), 
     vertex.label=NA, 
     mark.groups=by(seq_along(mcErdo$membership), mcErdo$membership, 
      invisible))
dev.off()

png(file="my_erdo_wtc.png")
opar <- par()$mar; par(mar=rep(0, 4));
plot(erdo, layout=layout, vertex.size=log(betweenness(erdo) + 1), 
     vertex.label=NA, 
     mark.groups=by(seq_along(wtcErdo$membership), wtcErdo$membership, 
      invisible))
dev.off()

plotStanfComm = function(egoStanfordFile, algo){
  egoS = read.graph(egoStanfordFile, directed=F)
  egoS = simplify(egoS, remove.multiple=T, remove.loops=T)
  if(algo == "mc"){
    algoCluster = fastgreedy.community(egoS)
  } else if(algo == "wtc"){
    algoCluster = walktrap.community(egoS)
  }
  egoSstr = sub("\\.edges", "", basename(egoStanfordFile))
  outf = paste0("stanford-", egoSstr, "-ego_", algo, ".png")
  png(file=outf)
  opar = par()$mar; par(mar=rep(0,4));
  layout <- layout.fruchterman.reingold(egoS, niter=500, 
              area=vcount(egoS)^2.3, repulserad=vcount(egoS)^2.8)
  plot(egoS, layout=layout, vertex.size=log(betweenness(egoS) + 1), 
    vertex.label=NA, 
    mark.groups=by(seq_along(algoCluster$membership), algoCluster$membership, 
      invisible))
  dev.off()
}
egoStanfordFiles = list.files("facebook_stanford", "edges", full.names=T)
l_ply(egoStanfordFiles, .fun=plotStanfComm, algo="mc")
l_ply(egoStanfordFiles, .fun=plotStanfComm, algo="wtc")











