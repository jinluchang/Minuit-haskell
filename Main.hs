
module Main where

import Minuit

main :: IO ()
main = do
    putStrLn "Hello world!"
    print $ migrad funcTest [1.2, 2.4] [0.1, 0.4]


