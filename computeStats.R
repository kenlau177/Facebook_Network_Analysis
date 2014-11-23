
localClusterCoef = function(G){
  #number of undirected connections between local's neighbour
  numer = length(E(G))
  denom = length(V(G))*length(V(G)-1)/2
  return(numer/denom)
}

computeGraphStats = function(G){
  avgShortestPath = average.path.length(G)
  transitivityG = transitivity(type="undirected", isolates="zero")      
  localClusterCoefG = localClusterCoef(G)
  return(list(avgShortestPath, transitivityG, localClusterCoefG))
}

computeNodeStats = function(G){
  out = data.frame(
    degree = degree(G), #Number of connections
    betweeness = betweeness(G), #Number of shortest path going through node
    closeness=closeness(G), #Number of steps required to access every other node
    )
  return(out)
}



