module FillMyPod.Random (randomize)
where

import Control.Applicative ((<$>))
import Control.Monad (join)
import System.Random (randomRIO)

randomize :: [t] -> IO [t]
randomize [] = return []
randomize lst =
  join (chooseWRandom lst <$> randomRIO (0, length lst - 1))

chooseEl :: [t] -> Int -> (t, [t])
chooseEl lst idx = (val, prefix ++ sTail)
  where (prefix, suffix) = splitAt idx lst
        val:sTail = suffix

chooseWRandom :: [t] -> Int -> IO [t]
chooseWRandom lst idx = (:) val <$> randomize tl
  where (val, tl) = chooseEl lst idx
