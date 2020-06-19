# Phylogenetic networks analysis of COVID19

## Getting covid data
https://www.cogconsortium.uk/data/
```
brew install wget
wget https://cog-uk.s3.climb.ac.uk/2020-05-08/cog_2020-05-08_sequences.fasta
wget https://cog-uk.s3.climb.ac.uk/2020-05-08/cog_2020-05-08_alignment.fasta
wget https://cog-uk.s3.climb.ac.uk/2020-05-08/cog_2020-05-08_metadata.csv
wget https://cog-uk.s3.climb.ac.uk/2020-05-08/cog_global_2020-05-08_tree.newick
```

## List of commands to MDL

1. Renamed `cog_2020-05-08_sequences.fasta` to `sequences.fasta`
2. Chosen 10 sequences into `10.fasta` with a package called [BBMap](https://sourceforge.net/projects/bbmap/)
3. We had to remove the `/` in the species names with the command:
```
sed 's/\//-/g' 10.fasta > 10-updated.fasta
```
4. Downloaded mdl from [here](https://github.com/nstenz/TICR/tree/master/src) and compiled without the Makefile. We used `g++` directly to create the `mdl` executable. We also downloaded the `paup` executable.
5. Run mdl with the command:
```
mdl.pl 10updated.fasta -b 100 -o 10mdl
```
We have to put the `10updated.fasta` in the `10mdl` folder before running the command.


Next step: do the same commands, but starting with `cog_2020-05-08_alignment.fasta`. Info on aligned vs unaligned sequence [here](http://www2.decipher.codes/Alignment.html)