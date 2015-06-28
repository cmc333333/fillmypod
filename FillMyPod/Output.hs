module FillMyPod.Output
(limit, printer, move, number, runCmd, filterByExt)
where

import Control.Applicative ((<$>))
import System.Cmd (system)
import System.Directory (renameFile)
import System.FilePath (replaceBaseName, replaceDirectory, takeExtension)
import Text.Printf (printf)


limit :: Int -> IO [FilePath] -> IO [FilePath]
limit len = fmap (take len)

printer :: IO [FilePath] -> IO [FilePath]
printer fpM = do fp <- fpM
                 mapM_ putStrLn fp
                 return fp

filterByExt :: String -> IO [FilePath] -> IO [FilePath]
filterByExt ext = fmap (filter hasExt)
  where hasExt = (dotExt ==) . takeExtension
        dotExt = "." ++ ext

replaceFiles :: ([FilePath] -> [(FilePath, FilePath)]) -> IO [FilePath] -> IO [FilePath]
replaceFiles zipWithReplacement fpM =
  do pairs <- zipWithReplacement <$> fpM
     mapM_ (uncurry renameFile) pairs
     return (map snd pairs)

move :: FilePath -> IO [FilePath] -> IO [FilePath]
move dest = replaceFiles zipWReplacement
  where zipWReplacement fps = zip fps (map replacement fps)
        replacement = flip replaceDirectory dest

number :: IO [FilePath] -> IO [FilePath]
number = replaceFiles zipWReplacement
  where indexes = map (printf "%03d" :: Int -> String) [1..]
        zipWReplacement fps = zip fps (zipWith replaceBaseName fps indexes)

runCmd :: String -> IO [FilePath] -> IO [FilePath]
runCmd cmd fpM = do fp <- fpM
                    mapM_ (system . (++) (cmd ++ " ")) fp
                    return fp
