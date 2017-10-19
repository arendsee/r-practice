require(igraph)

# create a singleton
a <- igraph::graph_from_literal(X)
b <- igraph::graph_from_literal(Y-Z)

ab <- igraph::union(a,b, byname=FALSE)
V(ab)

igraph::set_graph_attr(a, "hotend", value=3)
igraph::set_vertex_attr(a, "poo", value=333)
igraph::set_edge_attr(a, "stuffy", value=46)
