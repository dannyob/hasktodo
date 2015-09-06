{-# LANGUAGE OverloadedStrings #-}
module Main where

import ToDo

main :: IO ()
main = putStr $ show (parseLine "  this is me typing this @CURRENT #PROJECT @ANOTHERTAG(YEAH) this is great") 
