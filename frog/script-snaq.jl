using PhyloNetworks
data = readTrees2CF("Neobatrachus_single_gene_FULL.trees")
start_tree = readMultiTopology("Neobatrachus_single_gene_FULL.trees")[349]
using Distributed
addprocs(19)
@everywhere using PhyloNetworks
net0 = snaq!(start_tree,data, hmax=0, filename="net0", seed=456)
net1 = snaq!(net0,data, hmax=1, filename="net1", seed=789)
net2 = snaq!(net1,data, hmax=2, filename="net2", seed=123)

