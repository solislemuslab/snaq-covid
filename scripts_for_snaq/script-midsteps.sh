#!/bin/bash
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

