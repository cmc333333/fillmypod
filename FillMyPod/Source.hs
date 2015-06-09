module FillMyPod.Source
( Source(Dir)
, OrderedSource(Chronological, RandomlyOrdered), ordered
)
where

import Control.Applicative ((<$>))
import Control.Monad (join)
import Data.List (sort)
import Data.Time.Clock (UTCTime)
import System.Directory (getDirectoryContents, getModificationTime)
import System.FilePath (combine)

import FillMyPod.Random (randomize)

data Source =
  Dir FilePath
data OrderedSource =
  Chronological Source
  | RandomlyOrdered Source

ordered :: OrderedSource -> IO [FilePath]
ordered (Chronological (Dir filepath)) =
  join (sortByModTime <$> dirContents filepath)
ordered (RandomlyOrdered (Dir filepath)) =
  join (randomize <$> dirContents filepath)

pairWithModTime :: FilePath -> IO (UTCTime, FilePath)
pairWithModTime file = flip (,) file <$> getModificationTime file

sortByModTime :: [FilePath] -> IO [FilePath]
sortByModTime files = map snd . sort <$> pairsM
  where pairsM = mapM pairWithModTime files

dirContents :: FilePath -> IO [FilePath]
dirContents path = map addPrefix <$> pathsM
  where pathsM = filter (`notElem` [".", ".."]) <$> getDirectoryContents path
        addPrefix = combine path
