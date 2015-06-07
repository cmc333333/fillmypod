import FillMyPod.Source (Source(Dir), OrderedSource(RandomlyOrdered), ordered)

data Selector = 
  RandomRoundRobin [OrderedSource]

{-
oneRound :: [[t]] -> IO ([t], [[t]])
oneRound lst =
  let orderedM = randomize lst  :: IO [[t]]
      splitM = fmap (\l -> (take 1 l, drop 1 l)) orderedM  :: IO[([t], [t])]

selectFrom :: Selector -> IO [FilePath]
selectFrom (RandomRoundRobin sources) =
  let randomOrder = randomize sources :: IO [OrderedSource]
-}

main :: IO()
main = do result <- ordered (RandomlyOrdered (Dir "/tmp"))
          mapM_ putStrLn result
