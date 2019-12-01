module Utils
  ( splitOn
  , trim
  , mergeSpaces
  ) where

import Data.Char

splitOn :: Eq a => a -> [a] -> [[a]]
splitOn _ [] = []
splitOn s l =
  let (l0, l1) = break (==s) l
  in l0 : splitOn s (drop 1 l1)

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

mergeSpaces :: String -> String
mergeSpaces (' ' : ' ' : l) = mergeSpaces (' ' : l)
mergeSpaces (h:t) = h : mergeSpaces t
mergeSpaces [] = []
