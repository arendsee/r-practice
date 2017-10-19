require(network)

m <- matrix(rbinom(25,1,.4),5,5)
diag(m) <- 0
g <- network(m, directed=FALSE)
summary(g)


# add a global network attribute
set.network.attribute(g, "hotend", 3)
# create new edge attribute and set to 45 across all edges
set.edge.attribute(g, "stuffy", 46)
# to vertex
set.vertex.attribute(g, "poo", 333)


# getting all attributes
get.network.attribute(g, "hotend")
get.edge.attribute(g, "stuffy")
get.vertex.attribute(g, "poo")

# create a singleton
a <- network(matrix(1))
