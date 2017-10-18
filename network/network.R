require(network)

m <- matrix(rbinom(25,1,.4),5,5)
diag(m) <- 0
g <- network(m, directed=FALSE)
summary(g)


# add a global network attribute
set.network.attribute(g, "hotend", 3)
# to edge
set.edge.value(g)
# to edge
set.edge.attribute(g)
# to vertex
set.vertex.attribute(g)
