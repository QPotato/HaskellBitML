module Main (main) where

import BaseTypes
import Examples
import Prelude hiding ((!!), (++), (||))

main :: IO ()
main = print(show (escrowPut (Sats 10) (Sats 100) 10 5))
