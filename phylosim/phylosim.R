# This code is based on the phylosim vignette

library(phylosim)

# An icky global
PSIM_FAST <- TRUE

aa.seq <- AminoAcidSequence(length = 60)

# different substitution matrices
wag <- WAG()
jtt <- JTT()
lg  <- LG()
pam <- PAM()

summary(wag)
summary(jtt)
summary(lg)
summary(pam)

plot(wag, scale = 0.8)

# Construct a continuous deletor process:
cont.del <- ContinuousDeletor(
  rate       = 0.6,
  max.length = 10,
  dist       = expression(rnorm(1, mean = 5, sd = 3))
)

# Construct the template sequence for the \code{cont.ins.lg} insertion process:
templ.seq.wag <- AminoAcidSequence(length = 10)

# Clone the template sequence for the \code{cont.ins.wag} process:
templ.seq.lg <- clone(templ.seq.wag)

# Construct continuous insertor process object \code{cont.ins.wag}:
cont.ins.wag <- ContinuousInsertor(
  rate       = 0.6,
  max.length = 10,
  dist       = expression(rnorm(1, mean = 5, sd = 3))
)

# Construct continuous insertor process object \code{cont.ins.lg}:
cont.ins.lg <- ContinuousInsertor(
  rate       = 0.6,
  max.length = 10,
  dist       = expression(rnorm(1, mean = 5, sd = 3))
)

# Set up the template sequences for the insertion processes:
processes.site.wag <- list(wag, cont.ins.wag, cont.del)
processes.site.lg  <- list(lg, cont.ins.lg, cont.del)

templ.seq.wag$processes <- list(processes.site.wag)
templ.seq.lg$processes  <- list(processes.site.lg)

# Now the cont.ins.lg process samples the states from the equilibrium
# distribution of the LG model and cont.ins.wag samples the states from the WAG
# model.

# Disabling write protection for the insertion processes:
cont.ins.wag$writeProtected <- FALSE
cont.ins.lg$writeProtected <- FALSE

# Set the template sequence for the insertion processes:
cont.ins.wag$templateSeq <- templ.seq.wag
cont.ins.lg$templateSeq <- templ.seq.lg


# Setting up the insert hook for the insertion processes:
# Insert hook functions are called just before inserting the sequence generated
# by the insertion process.  This function allows for arbitrary modifications
# to be made to the inserted sequence object. In this case the insert hook
# functions sample the site-process specific rate multipliers of the
# substitution processes from an invariants plus discrete gamma (+I+d$\Gamma$)
# model:

cont.ins.wag$insertHook <- function(seq, target.seq, event.pos, 
    insert.pos) {
    plusInvGamma(seq, process = wag, pinv = 0.1, shape = 1)
    return(seq)
}
cont.ins.lg$insertHook <- function(seq, target.seq, event.pos, 
    insert.pos) {
    plusInvGamma(seq, process = lg, pinv = 0.1, shape = 1)
    return(seq)
}

# Now the processes are in place, so it is time to set up the root sequence.

aa.seq <- AminoAcidSequence(length = 60)

# Now we will create a pattern of processes. The ``left linker'', ``core'' and ``right linker'' regions evolve
# by different sets of processes. The core region has no indel processes attached, so its length will
# remain constant:

process.pattern <- c(rep(list(list(wag, cont.del, cont.ins.wag)), 
    times = 20), rep(list(list(jtt)), times = 20), rep(list(list(lg, 
    cont.del, cont.ins.lg)), times = 20))

# Apply the process pattern to the root sequence:
aa.seq$processes <- process.pattern

# Set up site specific rates by iterating over sites and sampling rates from
# a substitution process specific distribution:
for (i in 1:aa.seq$length) {
    if (isAttached(aa.seq$sites[[i]], jtt)) {
        setRateMultipliers(aa.seq, jtt, qnorm(runif(1,min=0.5,max=1),mean=0.001,sd=0.01), index = i)
    }
    else if (isAttached(aa.seq$sites[[i]], wag)) {
        plusInvGamma(aa.seq, process = wag, pinv = 0.1, shape = 1, 
            index = i)
    }
    else if (isAttached(aa.seq$sites[[i]], lg)) {
        plusInvGamma(aa.seq, process = lg, pinv = 0.1, shape = 1, 
            index = i)
    }
}

# Sample the states of the root sequence from the attached substitution processes:
sampleStates(aa.seq)
print(aa.seq)

# Plot the total rates of the sites:
plot(aa.seq)

# Read in a tree using the \code{ape} package:
tree <- read.tree(file = "smalldemotree.nwk")

# Construct the simulation object and get an object summary:
sim <- PhyloSim(phylo = tree, root.seq = aa.seq)
summary(sim)

# Plot the simulation object (tree with node labels):
plot(sim)

# A ``node hook'' is a function which accepts a \code{Sequence} object
# through the named argument ``seq'' and returns a \code{Sequence} object.
# After simulating the branch leading to the node, the resulting
# \code{Sequence} object is passed to the node hook and the returned object
# is used to simulate the downstream branches.

# Create a node hook function:
node.hook <- function(seq) {
    for (site in seq$sites) {
        if (isAttached(site, jtt)) {
            attachProcess(site, pam)
        }
    }
    return(seq)
}

# Attach the hook to node 8:
attachHookToNode(sim, node = 8, fun = node.hook)

# This \code{node.hook} function will attach the \code{pam} substitution process to all
# sites which have the \code{jtt} process attached (the ``core'' region). The affected sites
# will evolve with a doubled rate by a combination of substitution processes (\code{jtt} and \code{pam}) in the clade defined by the node - \code{(t4, t2)}.
#
# Run the simulation:
Simulate(sim)

# Save the resulting alignment, omitting the internal nodes:
saveAlignment(sim, file = "example_V3.1_aln.fas", skip.internal = TRUE)

# Plot the resulting alignment alongside the tree (including sequences at internal nodes):
plot(sim,num.pages=1)

file.remove("example_V3.1_aln.fas")
