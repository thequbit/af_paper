import json

files = ['linedata00','linedata00fft','linedata16','linedata16fft'];

results = {}
for file in files:

    # read file
    with open(file+'.csv','r') as f:
        line = f.read()
    
    # prepare line and split
    line = line.strip()
    numbers = line.split(',')
    
    # add numbers to array
    nums = []
    for number in numbers:
        nums.append(float(number))
    
    # save to results dict
    results[file] = { 'data': nums }
    
with open('linedata.json','w') as f:
    f.write('var linedata='+json.dumps(results));