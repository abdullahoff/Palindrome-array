import sys

def ispal(string,L):
   for i in range(L):
      if string[i] == string[L-1-i]:
         continue
      else:
         return False
   return True
#end ispal

# find the largest prefix of string 'string' of length 'L' that is a palindrome
def maxpal(string,L):
   max = 1  # single letter is a palindrome
   for L1 in range(2,L+1,2):
      if ispal(string[:L1],L1):
         max = L1
   return max
#end maxpal

def simple_display(palar,L):
   print("palindrome array:",end='')
   print(palar[0],end='')
   for i in range(1,L): 
      print(",",palar[i],end='')
   #end for
   print("")
#end simple_display


def display_line(palar,level,L):
   for i in range(L):
      if palar[i] < level+1:
         a = ' '
      else:
         a = '+'
      for j in range(palar[i]):
         print(a,end='')
      if i == L-1:
         print('')
         return
      else:
         if level == 0:
            print('.',end='')
         else:
            print(' ',end='')
   #end for
#end display_line


def fancy_display(palar,L):
   # find maximum value of palar
   max = 0
   for i in palar:
      if i > max : max = i
   for level in range(max-1,-1,-1):
      display_line(palar,level,L)
   #end for
#end fancy_display
   

def main():
   string = sys.argv[1]
   L = len(string)
   if L == 0:
      print("empty string")
      return
   elif L > 16:
      print("string too long")
      return
   else:
      print(string)
   palar=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] # "empty" array of size 16
   palar[L-1] = 1
   L1=L
   for i in range(L-1):
      palar[i] = maxpal(string[i:],L1)
      L1 = L1-1
   #end for
   simple_display(palar,L)
   fancy_display(palar,L)
#end main

main()
# try string 'aabbaa'
# try string 'abbabababbb'
# try string 'popokatettepetl'
