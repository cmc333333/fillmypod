import FillMyPod.Source (Source(Dir), OrderedSource(RandomlyOrdered))
import FillMyPod.Selector (Selector(RandomRoundRobin), selectFrom)

inputs :: [OrderedSource]
inputs = [RandomlyOrdered (Dir "/tmp"), RandomlyOrdered (Dir "/home/cmc")]

main :: IO()
main = do ordered <- selectFrom (RandomRoundRobin inputs)
          mapM_ putStrLn ordered
