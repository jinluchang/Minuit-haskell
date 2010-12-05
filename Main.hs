
module Main where

import Minuit

funcTest :: Double -> FcnFunction
funcTest par [x, y] = par + par * (sin x-0.4)**2 + 4*(y-4.2)**2
funcTest _ _ = error ""

main :: IO ()
main = do
    putStrLn "Hello world!"
    print $ migrad (funcTest 23) ["x", "y"] [7.2, 2.4] [0.1, 0.4]


