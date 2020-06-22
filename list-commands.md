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

    - Git clone TICR
    - In `src`, we tried `make` but got the error: error: linker command failed with exit code 1 (use -v to see invocation)
make: *** [mdl] Error 1
    - so, we compile with `g++ mdl.c -o mdl`
    - we made paup an executable file: `chmod +x paup`
    - We need to add `mdl` and `paup` to the path

5. Run mdl with the command:
```
mdl.pl 10updated.fasta -b 100 -o 10mdl
```
We have to put the `10updated.fasta` in the `10mdl` folder before running the command. This is happening if the folder already exists as mdl will look into the existing folder to continue the work.

Next step: do the same commands, but starting with `cog_2020-05-08_alignment.fasta`. Info on aligned vs unaligned sequence [here](http://www2.decipher.codes/Alignment.html)

### Commands on alignment fasta

First we tried with the 024.fasta, and it works:
```shell
## in snaq-covid/data
(master) $ ../scripts/TICR/scripts/mdl.pl 024.fasta -b 100 -o 024

Script was called as follows:
perl mdl.pl 024.fasta -b 100 -o 024

Will now proceed to breakdown '024.fasta' using a minimum block size of 100.

PAUP settings: gaps will not be treated as characters, missing and ambiguous sites will be included.
MDL settings: nletters = 4, nbestpart = 1, ngroupmax = 10000.

Input file '024.fasta' appears to be a FASTA file.
paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>
5446 total parsimony-informative sites found for '024.fasta'.

Parsimony analyses will be performed on 1540 different blocks.

Job server successfully created.
```

But it does not work with the 10-updated-alignment.fasta:
```shell
../scripts/TICR/scripts/mdl.pl 10-updated-alignment.fasta -b 100 -o 10fasta

Script was called as follows:
perl mdl.pl 10-updated-alignment.fasta -b 100 -o 10fasta

Will now proceed to breakdown '10-updated-alignment.fasta' using a minimum block size of 100.

PAUP settings: gaps will not be treated as characters, missing and ambiguous sites will be included.
MDL settings: nletters = 4, nbestpart = 1, ngroupmax = 10000.

Input file '10-updated-alignment.fasta' appears to be a FASTA file.
paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>paup>
4 total parsimony-informative sites found for '10-updated-alignment.fasta'.

Parsimony analyses will be performed on 1 different blocks.

Job server successfully created.

  Determining commands for each block... done. (0 - 0)
    Analyses complete: 1/1.
  All connections closed.

Total execution time: 2 seconds.
```
It only finds one block!

Now we try with the original alignments. But we need to remove the `/` in the species names with the command:
```
sed 's/\//-/g' cog_2020-05-08_alignment.fasta > cog-updated-alignments.fasta
```

Now, we run mdl in the original alignments:
```shell
../scripts/TICR/scripts/mdl.pl covid-genomes/cog-updated-alignments.fasta -b 100 -o cog
```