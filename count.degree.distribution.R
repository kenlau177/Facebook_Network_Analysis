
#Instead of intensities, this uses counts
#Credit goes to Richard O. Legendi for sharing the code
#http://www.r-bloggers.com/igraph-degree-distribution-count-elements/
count.degree.distribution <- function (graph, cumulative = FALSE, ...) 
{
  if (!is.igraph(graph)) {
    stop("Not a graph object")
  }
  cs <- degree(graph, ...)
  hi <- hist(cs, -1:max(cs), plot = FALSE)$count
  if (!cumulative) {
    res <- hi
  }
  else {
    res <- rev(cumsum(rev(hi)))
  }
  res
}

