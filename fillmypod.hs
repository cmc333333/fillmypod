import Control.Monad (join)
import Data.List (sort)
import Data.Time.Clock (UTCTime)
import System.Directory (getDirectoryContents, getModificationTime)
import System.FilePath (combine)
import System.Random (randomRIO)

data Source =
  Dir { filepath :: FilePath }
data OrderedSource =
  Chronological Source
  | RandomlyOrdered Source
data Selector = 
  RandomRoundRobin [OrderedSource]

pairWithModTime :: FilePath -> IO (UTCTime, FilePath)
pairWithModTime file =
  fmap (\t -> (t, file)) (getModificationTime file)

sortByModTime :: [FilePath] -> IO [FilePath]
sortByModTime files =
  let pairs = map pairWithModTime files
      pairsM = sequence pairs
      sortedM = fmap sort pairsM
  in  fmap (map snd) sortedM

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

randomize :: [t] -> IO [t]
randomize [] = return []
randomize lst =
  let idxM = randomRIO (0, length lst - 1)
      mM = fmap (randomizeWithIndex lst) idxM
  in  join mM

contentsPathsM :: FilePath -> IO [FilePath]
contentsPathsM path =
  let contentsM = getDirectoryContents path
      addPrefix = combine path
  in fmap (map addPrefix) contentsM

ordered :: OrderedSource -> IO [FilePath]
ordered (Chronological source) =
  let sortedM = fmap sortByModTime (contentsPathsM (filepath source))
  in  join sortedM
ordered (RandomlyOrdered source) =
  let sortedM = fmap randomize (contentsPathsM (filepath source))
  in  join sortedM

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

