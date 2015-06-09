import FillMyPod.Selector (Selector(RandomRoundRobin), selectFrom)
import FillMyPod.Source (Source(Dir), OrderedSource(RandomlyOrdered))
import FillMyPod.Output (limit, printer, number, move, runCmd)

inputs :: [OrderedSource]
inputs = [RandomlyOrdered (Dir "/tmp/place1")]

output :: IO [FilePath]
output = (runCmd "ls -l" . number . move "/tmp/place2" . printer . limit 10) (selectFrom (RandomRoundRobin inputs))

main :: IO()
main = do output
          return ()
