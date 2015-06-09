import FillMyPod.Selector (Selector(RandomRoundRobin), selectFrom)
import FillMyPod.Source (Source(Dir), OrderedSource(RandomlyOrdered))
import FillMyPod.Output (limit, printer, number, move)

inputs :: [OrderedSource]
inputs = [RandomlyOrdered (Dir "/tmp"), RandomlyOrdered (Dir "/home/cmc")]

output :: IO [FilePath]
output = (printer . number . (move "/ttt") . printer . (limit 10)) (selectFrom (RandomRoundRobin inputs))

main :: IO()
main = do output
          return ()
