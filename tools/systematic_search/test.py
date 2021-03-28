# Read inputs from Standard Input.
# Write outputs to Standard Output.

import sys

try:
    n = int(raw_input())
except ValueError:
    min_temp = 0;
    sys.stdout.write('0')
    exit();

if n > 10000 or n < 0:
    exit();

temp = str(raw_input())
if temp == '':
    min_temp = 0;
else:
    
    temp = [int(i) for i in temp.split(' ')]
    temp = [i for i in temp if i <= 5526 and i >= -273]

    pos_temp = [i for i in temp if i >= 0 ]
    neg_temp = [i for i in temp if i < 0 ]
    try:
        max_neg_temp = max(neg_temp)
    except ValueError:
        max_neg_temp = -273
    try:
        min_pos_temp = min(pos_temp)
    except ValueError:
        min_pos_temp = 5526
    
    min_temp = min_pos_temp
    if -1*max_neg_temp < min_pos_temp:
        min_temp = max_neg_temp


sys.stdout.write(str(min_temp))
