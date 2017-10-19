require(igraph)

# create a singleton from formulae, makes named graphs
a <- igraph::graph_from_literal(X)
b <- igraph::graph_from_literal(Y-Z)
ab <- a + b
V(ab)
plot(ab)

# create two graphs, default names are created
g1 <- make_empty_graph(directed=TRUE, n=5) + path(1:5)
g2 <- make_empty_graph(directed=TRUE, n=2) + path(1:2)
g3 <- make_empty_graph(directed=TRUE, n=6) + path(1:6)
g1 <- set_vertex_attr(g1, "color", value="green")
g2 <- set_vertex_attr(g2, "color", value="blue")
g3 <- set_vertex_attr(g3, "color", value="yellow")

# Link the final vertices of several graphs to a new vertex
funnel <- function(...){
  z <- make_empty_graph(directed=TRUE, n=1)
  z <- set_vertex_attr(z, "color", value="red")
  gs <- list(...)
  dg <- Reduce('+', x=gs[-1], init=gs[[1]]) + z
  for(i in Reduce('+', sapply(gs, vcount), 0, accumulate=TRUE)[-1]){
    dg <- dg + edge(i, vcount(dg))
  }
  dg
}
funnel(g1,g2,g3) -> ggg
plot(ggg)

# add a new node that contains a function of sink node, remove the previous value
propagate <- function(g, f){
  new_value <- f(get.vertex.attribute(g, "value", vcount(g)))
  new_node <- make_empty_graph(directed=TRUE, n=1) %>%
    set.vertex.attribute("value", 1, new_value)
  g <- set.vertex.attribute(g, "value", vcount(g), NA)
  g + new_node + edge(vcount(g), vcount(g)+1)
}
h <- make_empty_graph(directed=TRUE, n=1) %>% set_vertex_attr("value", 1, 16)
propagate(h, sqrt) %>% propagate(sqrt) %>% get.vertex.attribute
