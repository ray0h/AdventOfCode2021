#!/usr/bin/env python3

f = open('/home/roh/Projects/AdventOfCode2021/data/Day20.txt').read().splitlines() 
alg, img = f[0], f[2:] 
R, C = len(img), len(img[0])  

def img_enhance(r, c, n):  
    dx = [-1, -1 ,-1, 0 ,0 ,0, 1, 1, 1]
    dy = [-1, 0, 1, -1, 0, 1, -1, 0, 1]
    bistr = ''
    for x, y in zip(dx, dy):
        if 0<=r+x<R and 0<=c+y<C:
            if img[r+x][c+y] == '#': bistr += '1'
            if img[r+x][c+y] == '.': bistr += '0'
        else:
            # starts with 1 ( range(1,x) ), so invert the options
            if   n % 2 == 1: bistr += '0'
            elif n % 2 == 0: bistr += '1'
        
    return alg[int(bistr, 2)]

for i in range(1,3): # runs twice      
    # row, col expands by 1 in each side after each enhancement      
    after = [['-' for _ in range(R+2)] for _ in range(C+2)]     
    print(after)
    for r in range(R+2):         
        for c in range(C+2):                    
            after[r][c] = img_enhance(r-1, c-1, i) # after's (0, 0) is before's(-1, -1)  

    img = after     
    R, C = R+2, C+2  

print( sum([l.count('#') for l in img]) )