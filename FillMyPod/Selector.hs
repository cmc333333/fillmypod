module FillMyPod.Selector
( Selector(RandomRoundRobin)
, selectFrom
)
where

import Control.Applicative ((<$>))
import Control.Monad (join)

import FillMyPod.Random(randomize)
import FillMyPod.Source(OrderedSource, ordered)


data Selector =
  RandomRoundRobin [OrderedSource]

takeHeads :: [[t]] -> ([t], [[t]])
takeHeads lst = (concat heads, filter (not . null) tails)
  where (heads, tails) = unzip (map (splitAt 1) lst)

combineInIO :: ([t], [[t]]) -> IO [t]
combineInIO (heads, tails) = (heads ++) <$> recursiveRounds tails

recursiveRounds :: [[t]] -> IO [t]
recursiveRounds [] = return []
recursiveRounds lst =
  join (combineInIO . takeHeads <$> randomize lst)

selectFrom :: Selector -> IO [FilePath]
selectFrom (RandomRoundRobin sources) = join (recursiveRounds <$> ordSources)
  where ordSources = mapM ordered sources
