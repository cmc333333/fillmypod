# FillMyPod

## The Problem
Like many people, whenever I travel, I listen to mp3 files. Unlike most, however, I mostly listen to podcasts, audio books, and
recorded lectures; this means that I do not generally categorize by genre, artist, or album. Instead, I want to listen to the
files of an audio book sequentially, the files in a news podcast in reverse chronological order (perhaps just the top), and other
sources in a random order. FillMyPod allows you to do just that.

## Sources
Source objects (a.k.a. inputs) represent a source of mp3 files. Initially, these simply reference directories on your machine and
declare the order in which files from that directory are discovered. There is no reason to stop here, though. As long as a class
implements the iterator() method, returning an iterator of the Mp3 datastructure, you are good to go.

### Random
This source takes a path (without the trailing slash) as its parameter. All mp3s in the specified directory (or sub-directories of
said directory) will be returned in a random order.

### Chronological
This source is identical to Random save that it sorts the files chronologically (by modification time).

## Outputs
Output objects represent what modifications should be performed on the mp3s presented by the Sources. FillMyPod randomly selects one
of its sources, asks for the mp3, hands that mp3 to each of the Output objects, and then starts again until there are no more mp3s to
process. You should think of outputs more as a transformation than an end in themselves, however; see the Chain output below.

### Move
This output takes a directory (with no trailing slash) as its parameter. Each file that it receives will be moved from its current
location to that output directory.

### Copy
Similar to the Move output, this class copies the file to the output directory, leaving the original intact.

### Number
This output renames the files it is given to use a zero-padded index (e.g. 001.mp3, 002.mp3, etc.). The order of the index is
directly dependent on the order that the files are given (i.e. from the sources).

### Printer
This output simply prints the full path of each file it receives. This is useful for discovering which files were processed, and is
usually combined with the Chain output (see below).

### Limit
Taking a limiting number as its parameter, this output will allow through only the first X files. This is most useful when combined
with the Chain output (see below).

### Chain
As each output is really a transformation on the files it is given (i.e. it takes in files and spits out modified versions), we can
"chain" these outputs together. The Chain output does just that. It allows you to first limit the set of files to a smaller number
(say 10), print that list to the screen, and then copy them to some other location. See the examples below for more.


## Example(s)
This example takes 15 mp3 files from three different sources, prints which files it is copying, copies the files to a new location,
and then renames the files to match their order.

    from fillmypod import *
    from sources import *
    from outputs import *

    fmp = FillMyPod()
    fmp.addInput(Random("path/to/podcast"))
    fmp.addInput(Random("path/to/another/podcast"))
    fmp.addInput(Chronological("path/to/lecture"))
    fmp.addOutput(Chain([Limit(15), Printer(), Copy("path/to/new/location"), Number()]))
    fmp.run()
