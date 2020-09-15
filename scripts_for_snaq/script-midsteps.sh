#!/bin/bash
PATH=/opt/local/bin:/opt/local/sbin:/Library/Frameworks/Python.framework/Versions/3.7/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/yuzhengzhang/desktop/research/PhyloNetworks.jl.wiki/bucky1/src:/Users/yuzhengzhang/desktop/research/PhyloNetworks.jl.wiki/QMC:/Users/yuzhengzhang/Desktop/Research/PhyloNetworks.jl.wiki/data_results/scripts:/Users/yuzhengzhang/Desktop/Research/PhyloNetworks.jl.wiki/data_results/Covid-19:/Users/yuzhengzhang/Desktop/Research/PhyloNetworks.jl.wiki/MDL:/Users/yuzhengzhang/Desktop/Julia-1.4.app/Contents/Resources/julia/bin
name="$1"
mkdir "output-MDL/"$name
mkdir "output-MrBayes/"$name"-mb"
mkdir "output-bucky/"$name"-bucky"
cp "data/"$name".fasta" "output-MDL/"$name
mdl.pl "data/"$name".fasta" -b 100 -T 10 -o "output-MDL/"$name > "output-MDL/"$name"/command-output.txt"
mb.pl "output-MDL/"$name"/"$name".tar.gz" -m bayes.txt -T 10 -o "output-MrBayes/"$name"-mb" > "output-MrBayes/"$name"-mb/command-output.txt"
bucky.pl "output-MrBayes/"$name"-mb/"$name".mb.tar" -T 10 -o "output-bucky/"$name"-bucky" > "output-bucky/"$name"-bucky/command-output.txt"
get-pop-tree.pl "output-bucky/"$name"-bucky/"$name".CFs.csv" > "output-bucky/"$name"-bucky/command-output-QMC.txt"
mv $name".QMC.tre" "output-bucky/"$name"-bucky"
printf $name" works finished.\n"

