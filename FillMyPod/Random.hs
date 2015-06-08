module FillMyPod.Random (randomize)
where

import Control.Monad (join)
import System.Random (randomRIO)

randomize :: [t] -> IO [t]
randomize [] = return []
randomize lst =
  let idxM = randomRIO (0, length lst - 1)
      mM = fmap (randomizeWithIndex lst) idxM
  in  join mM

chooseEl :: [t] -> Int -> (t, [t])
chooseEl lst idx =
  let val = lst !! idx
      prefix = take idx lst
      suffix = drop (idx + 1) lst
  in (val, prefix ++ suffix)


randomizeWithIndex :: [t] -> Int -> IO [t]
randomizeWithIndex lst idx =
  let (h, t) = chooseEl lst idx
      randomTail = randomize t
  in fmap ((:) h) randomTail
