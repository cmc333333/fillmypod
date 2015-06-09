# FillMyPod

## The Problem
Like many people, whenever I travel, I listen to mp3 files. Unlike most,
however, I largely listen to podcasts, audio books, and recorded lectures;
this means that I do not generally categorize by genre, artist, or album.
Instead, I want to listen to the files of an audio book sequentially, the
files in a news podcast in reverse chronological order (perhaps just the top),
and other sources in a random order. FillMyPod allows you to do just that.

## Sources and OrderedSources
Source objects (a.k.a. inputs) represent a source of mp3 files. These simply
reference directories on your machine. Sources are augmented to become
OrderedSources, which allow the files in the Source to be retrieved in a
particular order. Note that we assume the directory in question only contains
mp3 files.

### Random
This OrderedSource will return the results in a random order. This is most
likely the type you want for your files as it provides the most variety.

### Chronological
This OrderedSource will return the files sorted chronologically, by
modification time, in ascending order. It should generally be used for
serials, lectures, etc.

## Selectors
Now that we have our collection of OrderedSources, we need to determine how to
use them to fill up the mp3 player. 

### RandomRoundRobin
This will sort the _sources_ randomly, pulling one file out of each. Once each
source has been touched, the list is sorted again and repeated until there are
no more files available.

## Outputs
Now that we have our inputs and selectors, we will want to transform the mp3
files. We'll want to move the files around, log them, compress them, etc. Note
that, as Outputs are composable, they can be chained to create more
interesting results.

### Limit
We're largely evaluating with lazy lists/iterators. The Limit output makes
sure that we only select a certain number of these elements -- we don't want
to listen to _all_ of our podcasts in one go.

### Printer
This output simply prints the full path of each file it receives. This is
useful for discovering which files were processed.

### Move
This output takes a directory as its parameter. Each file that it receives
will be moved from its current location to that output directory.

### Number
This output renames the files it is given to use a zero-padded index (e.g.
001.mp3, 002.mp3, etc.). The order of the index is directly dependent on the
order that the files are given (i.e. from the sources).

### runCmd
This output sends the file to an external program. The interface is very
simple; it assumes that the external program accepts a filename as its last
parameter.


## Example(s)
This example takes 15 mp3 files from three different sources, prints which
files it is processing, moves the files to a new location and then renames
them to match their order.

```
import FillMyPod.Selector (Selector(RandomRoundRobin), selectFrom)
import FillMyPod.Source (Source(Dir), OrderedSource(RandomlyOrdered))
import FillMyPod.Output (limit, printer, number, move, runCmd)

inputs :: [OrderedSource]
inputs = [RandomlyOrdered (Dir "path/to/podcast"),
          RandomlyOrdered (Dir "path/to/another/podcast"),
          Chronological (Dir "path/to/lecture")]

output :: IO [FilePath]
output = (number . move "path/to/new/location" . printer . limit 15) (selectFrom (RandomRoundRobin inputs))

main :: IO()
main = do output
          return ()
```
