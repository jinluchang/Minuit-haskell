
module Main where

import Minuit

funcTest :: FcnFunction
funcTest [x, y] = 2 + (x-0.4)**2 + 4*(y-4.2)**2
funcTest _ = error ""

main :: IO ()
main = do
    putStrLn "Hello world!"
    print $ migrad funcTest ["x", "y"] [1.2, 2.4] [0.1, 0.4]


