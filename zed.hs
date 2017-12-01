--Haskell Kingdom of Zed Project
--Specification on http://www.cs.sfu.ca/CourseCentral/383/pjj/a1.html
--Identical to the Skyscrappers Puzzle

--By Joanna Tu, Kayci Wang, Nathan Tong

import qualified Data.List as L -- aliased to L

--zed :: [[Int]]-> [[Int]]
zed lst = putStr . unlines $ map show (convert(kingdomOfZedSolver lst))

convert:: Maybe [[Int]] -> [[Int]]
convert (Just a) = a
convert Nothing = [[],[],[],[]]

--REQUIRES: input lst must be an array of four arrays each with the same length
kingdomOfZedSolver :: [[Int]] -> Maybe [[Int]]
kingdomOfZedSolver lst = solve lst 0 0 (length (head lst)) (generateEmptyGrid (length (head lst)) (length (head lst))) (combos (length (head lst)))

-- GENERATES ALL PERMUTATIONS 
combos :: Int -> [[Int]]
combos n = L.permutations [1..n]

solve :: [[Int]] -> Int -> Int -> Int -> [[Int]] -> [[Int]] -> Maybe [[Int]]
solve lst row column max grid permutation
 |row >= max = Just grid
 |row < max = if ((grid!!row)!!0 == 0) then (tryPerm 0 max grid row column lst permutation) else (solve lst (row+1) column max grid permutation)
 

-- GENERATES COLUMN OF EMPTY LISTS e.g. [[],[],[]]
-- input: number of rows, number of columns
generateEmptyGrid 0 _ = []
generateEmptyGrid row column = (generateEmptyList column) : (generateEmptyGrid (row-1) column)

generateEmptyList 0 = []
generateEmptyList column = 0 : generateEmptyList (column - 1)

replaceNth n newVal (x:xs)
 | n == 0 = newVal:xs
 | otherwise = x:replaceNth (n-1) newVal xs 

-- FILLS IN PERMUTATION IN PERMLIST AT INDEX N, FILLS IN THE INDICATED ROW OF THE GRID
fillIn :: Int -> Int -> [[Int]] -> [[Int]] -> [[Int]]
fillIn n row permlist (x:xs)
 | row == 0 = (permlist!!n):xs
 | otherwise = x:fillIn n (row-1) permlist xs

-- EDITED TO TRY PERMUTATIONS (WHOLE ROWS) INSTEAD OF SINGLE VALUES
--inner forloop, going through each possible number and validate
tryPerm :: Int -> Int -> [[Int]] -> Int -> Int -> [[Int]] -> [[Int]] -> Maybe [[Int]]
tryPerm permToTry max grid row column lst permutation
 |permToTry >= (length permutation) = Nothing
 |validate row column (fillIn permToTry row permutation grid) max lst == True
  = if ((solve lst row column max (fillIn permToTry row permutation grid) permutation) == Nothing) then
    (tryPerm (permToTry+1) max grid row column lst permutation) else (solve lst row column max (fillIn permToTry row permutation grid) permutation)
 |otherwise = tryPerm (permToTry+1) max grid row column lst permutation

--VALIDATION STEP: VALIDATES EACH ROW/COLUMN AND CHECK FOR DUPLICATES,
--                 VALIDATES FOUR SIDES AND CHECK TO MATCH IF EACH ROW AND EACH COLUMN MATCH THE CORRESPONDING MERCHANT CLUE
validate row column grid max lst
 |row == (max-1) 
  = (checkIfEachColumnInThisRowIsValid row 0 grid max)
  && (checkIfValidWithTopSkyScraperNumberFull row column grid max lst)
  && (checkIfValidWithRightSkyScraperNumber row column grid max lst)
  && (checkIfValidWithBottomSkyScraperNumberFull row column grid max lst)
  && (checkIfValidWithLeftSkyScraperNumber row column grid max lst)
 |otherwise
  =(checkIfEachColumnInThisRowIsValid row 0 grid max)
  && (checkIfValidWithAllTopSkyScraperNumber row column grid max lst)
  && (checkIfValidWithRightSkyScraperNumber row column grid max lst)
  && (checkIfValidWithLeftSkyScraperNumber row column grid max lst)

--position is my current position at the specific column in that row
checkIfEachColumnInThisRowIsValid row column grid max
 |column == max = True
 |checkIfEachColumnIsValid row column grid max 0 == True = checkIfEachColumnInThisRowIsValid row (column+1) grid max
 |otherwise = False

checkIfEachColumnIsValid row column grid max position
 |position == max = True
 |position == row = checkIfEachColumnIsValid row column grid max (position + 1)
 |(grid!!row)!!column == (grid!!position)!!column = False
 |otherwise = checkIfEachColumnIsValid row column grid max (position + 1)

checkIfValidWithAllTopSkyScraperNumber row column grid max lst
 |column == max = True
 |(lst!!0)!!column == 0 = checkIfValidWithAllTopSkyScraperNumber row (column+1) grid max lst
 |(sumUpAscendingNumColumn 0 column grid max 0) > (lst!!0)!!column = False
 |otherwise = checkIfValidWithAllTopSkyScraperNumber row (column+1) grid max lst

checkIfValidWithTopSkyScraperNumberFull row column grid max lst
 |column == max = True
 |(lst!!0)!!column == 0 = checkIfValidWithTopSkyScraperNumberFull row (column+1) grid max lst
 |(sumUpAscendingNumColumn 0 column grid max 0) /= (lst!!0)!!column = False
 |otherwise = checkIfValidWithTopSkyScraperNumberFull row (column+1) grid max lst

checkIfValidWithRightSkyScraperNumber row column grid max lst
 |(lst!!1)!!row == 0 = True
 |(sumUpAscendingNumRow1 row (max-1) grid 0 0) /= (lst!!1)!!row = False
 |otherwise = True

checkIfValidWithBottomSkyScraperNumberFull row column grid max lst
 |column == max = True
 |(lst!!2)!!((max-1)-column) == 0 = checkIfValidWithBottomSkyScraperNumberFull row (column+1) grid max lst
 |(sumUpAscendingNumColumn1 (max-1) column grid 0 0) /= (lst!!2)!!((max-1)-column) = False
 |otherwise = checkIfValidWithBottomSkyScraperNumberFull row (column+1) grid max lst

checkIfValidWithLeftSkyScraperNumber row column grid max lst
 |(lst!!3)!!((max-1)-row) == 0 = True
 |(sumUpAscendingNumRow row 0 grid max 0) /= (lst!!3)!!((max-1)-row) = False
 |otherwise = True

sumUpAscendingNumColumn row column grid max keeper
 |row == max = 0 
 |(grid!!row)!!column == 0 = sumUpAscendingNumColumn (row+1) column grid max keeper
 |(grid!!row)!!column > keeper = 1 + (sumUpAscendingNumColumn (row+1) column grid max ((grid!!row)!!column))
 |otherwise = sumUpAscendingNumColumn (row+1) column grid max keeper

sumUpAscendingNumRow row column grid max keeper
 |column == max = 0
 |(grid!!row)!!column == 0 = sumUpAscendingNumRow row (column+1) grid max keeper
 |(grid!!row)!!column > keeper = 1 + (sumUpAscendingNumRow row (column+1) grid max ((grid!!row)!!column))
 |otherwise = sumUpAscendingNumRow row (column+1) grid max keeper

sumUpAscendingNumColumn1 row column grid min keeper
 |row < min = 0 
 |(grid!!row)!!column == 0 = sumUpAscendingNumColumn1 (row-1) column grid min keeper
 |(grid!!row)!!column > keeper = 1 + (sumUpAscendingNumColumn1 (row-1) column grid min ((grid!!row)!!column))
 |otherwise = sumUpAscendingNumColumn1 (row-1) column grid min keeper

sumUpAscendingNumRow1 row column grid min keeper
 |column < min = 0
 |(grid!!row)!!column == 0 = sumUpAscendingNumRow1 row (column-1) grid min keeper
 |(grid!!row)!!column > keeper = 1 + (sumUpAscendingNumRow1 row (column-1) grid min ((grid!!row)!!column))
 |otherwise = sumUpAscendingNumRow1 row (column-1) grid min keeper





