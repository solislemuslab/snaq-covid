#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import random 
fasta = open("global.fa","rt")
count = 0
symbol = ">"
lines = fasta.readlines()
for line in lines:
        if(line.find(symbol) != -1):
            print(count)
            print(line)
        count+=1
def extract(seed,size): 
    content = []
    check = []
    random.seed(892)
    for x in range(10000):
        rand_num = random.randint(0,70958)
        if rand_num not in check:
            check.append(rand_num)
            content += lines[rand_num*496:(rand_num+1)*496]
            if len(check)==size:
                break
    new = open("sample1.fasta", "w")
    count = 0
    for line in content:
        new.write(line)
        count+=1
    print(len(check))
    new.close()
    # then we need to replace "\" by sed 's/\//-/g' in terminal

