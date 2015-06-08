module FillMyPod.Selector
( Selector(RandomRoundRobin)
, selectFrom
)
where

import Control.Monad (join)

import FillMyPod.Random(randomize)
import FillMyPod.Source(OrderedSource, ordered)


data Selector =
  RandomRoundRobin [OrderedSource]

takeHeads :: [[t]] -> ([t], [[t]])
takeHeads lst =
  let heads = map (take 1) lst
      flattenedHeads = concat heads
      tails = map (drop 1) lst
      remainingTails = filter (not . null) tails
  in (flattenedHeads, remainingTails)

combineInIO :: ([t], [[t]]) -> IO [t]
combineInIO (heads, tails) =
  let tailM = recursiveRounds tails
  in fmap (heads ++) tailM

recursiveRounds :: [[t]] -> IO [t]
recursiveRounds [] = return []
recursiveRounds lst =
  let orderedM = randomize lst
      combined = fmap (combineInIO . takeHeads) orderedM
  in join combined

selectFrom :: Selector -> IO [FilePath]
selectFrom (RandomRoundRobin sources) =
  let sorted = map ordered sources
      seqM = sequence sorted
  in join (fmap recursiveRounds seqM)
