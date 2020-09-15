import sys
import random
fasta = open("concatenated.fasta","rt")
count = 0
symbol = ">"
lines = fasta.readlines()
content = []
list_check_repeats = []
new = open("data/"+sys.argv[1]+".fasta", "w")
record = open("data/record/"+sys.argv[1]+"-alignment-index.txt", "w")
random.seed(sys.argv[2])
record.write("the random seed to generate all indexes is: "+str(sys.argv[2])+"\n")
record.write("indexes for randomly chosen alignments: ")
for x in range(10): 
  rand_num = random.randint(0,121)
  if rand_num in list_check_repeats:
    record.truncate(0)
    record.close()
    new.close()
    fasta.close()
    print("Duplicate indexes occurs, please give another seed.")
    quit()
  list_check_repeats.append(rand_num)
  content+= lines[2*rand_num:2*rand_num+2]
  record.write(str(rand_num)+" ")
for line in content:
  new.write(line)
  count+=1
print("number of random alignments:"+ str(count))
record.close()
new.close()
fasta.close()
