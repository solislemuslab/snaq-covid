Pkg.add("PhyloNetworks")
using PhyloNetworks
using PhyloPlots
using Random
record = open("output-snaq/record/"*ARGS[1]*"-record.txt","w")
buckyCF = readTableCF("output-bucky/"*ARGS[1]*"-bucky/"*ARGS[1]*".CFs.csv")
tre = readTopology("output-bucky"*ARGS[1]*"-bucky/"*ARGS[1]*".QMC.tre")
seeds = rand(MersenneTwister(ARGV[2]),0:10000,3)
write(record,"MersenneTwister seed: "*ARGS[2]*"\n")
write(record,"3 seeds for snaq: ")
write(record,string(seeds[1])*" ")
write(record,string(seeds[2])*" ")
write(record,string(seeds[3])*" ")
net0 = snaq!(tre,  buckyCF, hmax=0, filename="output-snaq/"*ARGS[1]*"-snaq/net0", seed=seeds[1])
net1 = snaq!(net0, buckyCF, hmax=1, filename="output-snaq/"*ARGS[1]*"-snaq/net1", seed=seeds[2])
net2 = snaq!(net1, buckyCF, hmax=2, filename="output-snaq/"*ARGS[1]*"-snaq/net2", seed=seeds[3])
close(record)
