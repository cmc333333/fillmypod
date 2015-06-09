module FillMyPod.Output
(limit, printer, move, number)
where

import System.FilePath (replaceBaseName, replaceDirectory)
import Text.Printf (printf)


limit :: Int -> IO [FilePath] -> IO [FilePath]
limit len = fmap (take len)

printer :: IO [FilePath] -> IO [FilePath]
printer fpM = do fp <- fpM
                 mapM_ putStrLn fp
                 return fp

move :: FilePath -> IO [FilePath] -> IO [FilePath]
move dest = fmap (map (flip replaceDirectory dest))

number :: IO [FilePath] -> IO [FilePath]
number fpM =
  let zeroPad = printf "%03d" :: Int -> String
      indexes = map zeroPad [1..]
      withIdxM = fmap (flip zip indexes) fpM
      renamedM = fmap (map (uncurry replaceBaseName)) withIdxM
  in renamedM

data Output =
  Run String
