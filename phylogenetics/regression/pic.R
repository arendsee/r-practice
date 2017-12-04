library(ape)

# This example is adapted from the ape documentation. I am not sure what X and
# Y represent; probably they are simulated data. See Joseph Felsenstein (1985)
# 'Phylogenies and the Comparative Method' for details on the method (and a
# very nice introduction to the problem).

tree.primates <- read.tree(text="((((Homo:0.21,Pongo:0.21):0.28,Macaca:0.49):0.13,Ateles:0.62):0.38,Galago:1.00);")
X <- c(Homo=4.09, Pongo=3.61, Macaca=2.37, Ateles=2.03, Galago=-1.47)
Y <- c(Homo=4.74, Pongo=3.33, Macaca=3.37, Ateles=2.89, Galago=2.30)
pic.X <- pic(X, tree.primates)
pic.Y <- pic(Y, tree.primates)
cor.test(pic.X, pic.Y)

# Regression on the raw values, assuming independence
fit <- lm(X ~ Y - 1)
# Appears to be significant: p-value = 0.03
summary(fit)

# Regression on the phylogenetically independent contrasts
fit <- lm(pic.X ~ pic.Y - 1)
# Appears NOT to be significant: p-value = 0.2
summary(fit)
