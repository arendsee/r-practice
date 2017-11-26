# Phylogenetic methods in R

There are many, many R packages for phylogenetics. I will tree to summarize
them here, adding details as I gather them.

 1. `ape`
     - drop.tip(phy, tip) - drop a tip or node (and its descendents)
     - extract.clade(phy, node) - delete everything not descending from a node

 2. `taxize*`

 3. `ggtree` - bioconductor package for tree visualization
     * well documented
     * actively maintained

 4. `ggphylo` - tree visualization
    * not well-maintained or as pretty as `ggtree`
    * has some nice general utilities
    * support for many input formats
      - Newick
      - Nexus
      - NHX
      - jplace
      - Phylip
      - supports software outputs from BEAST3, EPA4, HYPHY5, PAML6, PHYLDOG7,
        pplacer8, r8s9, RAxML10 and RevBayes11

 5. `phyloseq` - Bioconductor package for general phylogenetics

 6. `OutBreakTools` - tree visualization and more ...

 7. `phytools` - a giant collection of functions for phylogenetics, a few useful things:
     - getDescendents
     - getSisters
     - getParent
     - paste.tree
     - bind.tip(tree, tip.label, where)

 8. `geiger`
    - tips(tree, node) - get descendents of a node
