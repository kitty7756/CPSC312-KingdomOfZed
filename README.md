# CPSC312-KingdomOfZed

###Project Description on http://www.cs.sfu.ca/CourseCentral/383/pjj/a1.html

###Identical to the Skyscrapers Puzzle on http://www.brainbashers.com/skyscrapers.asp


Calling kingdomOfZedSolver INPUT returns either NOTHING, or a solution Just a if a it exists.

INPUT is an array of array that requires four array entries, and each array entry with the same length.


##Our implementation: 
works with any nxn grid, 

allows incomplete information. For this option, merchants may withold information from you. If they do, their clue is represented as a 0 (zero). 

displays the output as a grid (not a list).

implements one or more solving strategies.


##For example: 
```
kingdomOfZedSolver [[2,1],[1,2],[2,1],[1,2]]

Just [[1,2],[2,1]]

kingdomOfZedSolver [[2,2,1],[1,2,2],[3,1,2],[2,1,3]]

Just [[1,2,3],[3,1,2],[2,3,1]]

>kingdomOfZedSolver [[1,3,2,2],[3,2,1,2],[2,2,1,3],[2,2,3,1]]

>Just [[4,1,3,2],[2,3,4,1],[3,2,1,4],[1,4,2,3]]

>kingdomOfZedSolver [[4,2,2,1,3],[2,3,2,1,4],[2,5,2,2,1],[1,2,2,2,4]]

>Just [[1,2,4,5,3],[3,5,2,4,1],[2,1,5,3,4],[4,3,1,2,5],[5,4,3,1,2]]

>kingdomOfZedSolver [[0,1,2,0],[0,0,0,2],[3,0,3,0],[0,0,0,0]]

>Just [[1,4,3,2],[2,3,1,4],[4,1,2,3],[3,2,4,1]]

Also by calling zed INPUT displays the result as a grid 

>zed [[0,1,2,0],[0,0,0,2],[3,0,3,0],[0,0,0,0]]

>[1,4,3,2]

>[2,3,1,4]

>[4,1,2,3]

>[3,2,4,1]
```


##Our solving strategy is:

1) generate all possible permutations based on a give n

2) starting from the top most row, try each permutation:

     -if it satisfies the RIGHT, LEFT, and TOP numbers provided by the merchant, and no duplication in each COLUMN
      we keep that row and going to the next row
      
     -discard the row and try another permutation
     
3) if all permutations don't work for one row, we go back one row and change its permutation.

4) once we reach the last row, other than checking all RIGHT,LEFT,TOP,duplication in COLUMN, we also check BOTTOM numbers.

5) once a solution is found, it is returned, else NOTHNG is returned.

