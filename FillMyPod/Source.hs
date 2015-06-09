module FillMyPod.Source
( Source(Dir), filepath
, OrderedSource(Chronological, RandomlyOrdered), ordered
)
where

import Control.Monad (join)
import Data.List (sort)
import Data.Time.Clock (UTCTime)
import System.Directory (getDirectoryContents, getModificationTime)
import System.FilePath (combine)

import FillMyPod.Random (randomize)

data Source =
  Dir { filepath :: FilePath }
data OrderedSource =
  Chronological Source
  | RandomlyOrdered Source

ordered :: OrderedSource -> IO [FilePath]
ordered (Chronological source) =
  let sortedM = fmap sortByModTime (contentsPathsM (filepath source))
  in  join sortedM
ordered (RandomlyOrdered source) =
  let sortedM = fmap randomize (contentsPathsM (filepath source))
  in  join sortedM

pairWithModTime :: FilePath -> IO (UTCTime, FilePath)
pairWithModTime file =
  fmap (\t -> (t, file)) (getModificationTime file)

sortByModTime :: [FilePath] -> IO [FilePath]
sortByModTime files =
  let pairs = map pairWithModTime files
      pairsM = sequence pairs
      sortedM = fmap sort pairsM
  in  fmap (map snd) sortedM

contentsPathsM :: FilePath -> IO [FilePath]
contentsPathsM path =
  let contentsM = getDirectoryContents path
      addPrefix = combine path
      isDots = flip elem [".", ".."]
      pathsM = fmap (filter (not . isDots)) contentsM
  in fmap (map addPrefix) pathsM

