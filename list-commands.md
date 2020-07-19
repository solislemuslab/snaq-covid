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
I write some Python code to extract specific number of alignments(1000) from the fasta file "alignment.fasta" which is the whole alignments file.
The new file called try.fasta.
```
fasta = open("alignment.fasta","rt")
count = 0
symbol = ">"
lines = fasta.readlines()
new = open("try.fasta", "w")
content = lines[10000:11001]
count = 0
for line in content:
    new.write(line)
    count+=1
print(count)
```
Then I write command in jupyter notebook for the preparation of MDL
```
!PATH=/opt/local/bin:/opt/local/sbin:/Library/Frameworks/Python.framework/Versions/3.7/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/yuzhengzhang/desktop/research/PhyloNetworks.jl.wiki/bucky1/src:/Users/yuzhengzhang/desktop/research/PhyloNetworks.jl.wiki/QMC:/Users/yuzhengzhang/Desktop/Research/PhyloNetworks.jl.wiki/data_results/scripts:/Users/yuzhengzhang/Desktop/Research/PhyloNetworks.jl.wiki/data_results/Covid-19:/Users/yuzhengzhang/Desktop/Research/PhyloNetworks.jl.wiki/MDL
!sed 's/\//-/g' try.fasta > try-updated.fasta
!mkdir try
!cp try-updated.fasta try-updated
```
Then I run MDL command
```
mdl.pl try-updated.fasta -b 100 -o try
```
We still get only 1 partition
```
164 total parsimony-informative sites found for 'try-updated.fasta'.

Parsimony analyses will be performed on 3 different blocks.

Job server successfully created.

  Determining commands for each block... done. (0 - 2)
    Analyses complete: 3/3.
  All connections closed.

Total execution time: 4 minutes, 27 seconds.
```

We think there are two possibilities account for this very few number of parsimony sites: problem of MDL or problem of data of COVID_19
SO I write some python code to compare pairs of alignments in the COVID-19 dataset to identify the difference between two alignments.
I randomly chooses pairs of alignments and divide them to sections and each section has 100 sites.Then I compare each section of two alignments,
if two corresponding sections are different, i write sections to two files. Then compare each site in those two files to count the number of different sites and the position of it. I use this way to compare because this way is much faster than the simple compare(compare each site one by one)
Also, Since "N' is represented as any base, so i did not count those sites as difference sites.(for example, ATAN and ATGA, I count there is only 1 difference site)So, if I do not count "N", there are only about 5-7 different sites of each pair of alignments in my sample file( I chose 1th, 5000th, 8000th, 8500th, 10000th,11015th, 12150th, 13525th alignment).
```
compare1 = open("compare1.txt","w")
content1 = lines[19000:19002]
compare2 = open("compare2.txt","w")
content2 = lines[16000:16002]
for line in content1:
    compare1.write(line)
for line in content2:
    compare2.write(line) 
    
compare1 = open("compare1.txt","r")
compare2 = open("compare2.txt","r")
compare11 = open("compare11.txt","w")
compare22 = open("compare22.txt","w")
content11 = []
content22 = []
count = 0
while 1:
    compare1_reader = compare1.read(100)
    compare2_reader = compare2.read(100)
    if(compare1_reader != compare2_reader):
        content11.append(compare1_reader)
        content22.append(compare2_reader)
        count+=1
        print(count)
        print(compare1_reader)
compare11 = open("compare11.txt","w")
compare22 = open("compare22.txt","w")
for line in content11:
    compare11.write(line)
for line in content22:
    compare22.write(line)
 
compare22 = open("compare22.txt","r")
num = 0
while 1:
    num+=1
    compare11_reader = compare11.read(1)
    compare22_reader = compare22.read(1)
    if(compare11_reader != compare22_reader and compare11_reader!="N" and compare22_reader!="N"):
        print(compare11_reader)
        print(num)
```
Also from https://www.ncbi.nlm.nih.gov/projects/msaviewer/?key=1WZPv8lkFr26Sli6mVtuRD7oyOGXkJmVlZO9hamBu68qnFQ-DARtgFK7Z7jLX5AiwTqcLoIK2Q-eFYoYjB6ABbIsjyKjHok,oRI7y70QYsnOPizO7S8aMEqP4SG-ULBVvFOURYBBkm8DXH3-JcSP47nJjJLbgDv9auU38SnVctA1yiHHJ8Er2hnzJP0IwSI I checked the pattern of our COVID-19 data which have same result with my python result.
Then I registered the account in GISAID to get another COVID-19 data, and I download the msa file. After randomly choose 10 alignments and run MDL, I find there are also very few number of parsimony informative sites.(1 partition) 
```
mdl.pl msa_sample1.fasta -b 100 -sample1
```
Then we decide to use pseudomona data instead of COVID-19. I randomly choose 10 alignments in this data set.
```
fasta = open("concatenated.fasta","rt")
count = 0
symbol = ">"
lines = fasta.readlines()
for line in lines:
        if(line.find(symbol) != -1):
            print(count)
            print(line)
        count+=1
        
new = open("sample1.fasta", "w")
content = lines[0:4]
content+=lines[20:24]
content+=lines[50:54]
content+=lines[60:64]
content+=lines[84:88]
count = 0
for line in content:
    new.write(line)
    count+=1
print(count)
```
Then I run the command of MDL
```
mdl.pl sample1.fasta -b 100 -o sample1
```
I get good results and get good partitions.
