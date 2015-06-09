module FillMyPod.Output
(limit, printer, move, number, runCmd)
where

import System.Cmd (system)
import System.Directory (renameFile)
import System.FilePath (replaceBaseName, replaceDirectory)
import Text.Printf (printf)


limit :: Int -> IO [FilePath] -> IO [FilePath]
limit len = fmap (take len)

printer :: IO [FilePath] -> IO [FilePath]
printer fpM = do fp <- fpM
                 mapM_ putStrLn fp
                 return fp

move :: FilePath -> IO [FilePath] -> IO [FilePath]
move dest fpM = 
  let replacement = flip replaceDirectory dest
      zipWReplacement fps = zip fps (map replacement fps)
      pairsM = fmap zipWReplacement fpM
  in do pairs <- pairsM
        mapM_ (uncurry renameFile) pairs
        return (map snd pairs)

number :: IO [FilePath] -> IO [FilePath]
number fpM =
  let zeroPad = printf "%03d" :: Int -> String
      indexes = map zeroPad [1..]
      withIdxM = fmap (`zip` indexes) fpM
      pairsM = fmap (map (\(f,n) -> (f, replaceBaseName f n))) withIdxM
  in do pairs <- pairsM
        mapM_ (uncurry renameFile) pairs
        return (map snd pairs)

runCmd :: String -> IO [FilePath] -> IO [FilePath]
runCmd cmd fpM = do fp <- fpM
                    mapM_ (system . (++) (cmd ++ " ")) fp
                    return fp
