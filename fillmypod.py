import sys
from sources import *
from outputs import *

class FillMyPod(object):
  def __init__(self):
    self.__inputs = []
    self.__outputs = []
  def addInput(self, source):
    self.__inputs.append(source)
  def addOutput(self, output):
    self.__outputs.append(output)
  def __roundRobin(self):
    iterators = map(lambda itty: itty.iterator(), self.__inputs)
    while len(iterators) > 0:
      for itty in iterators:
        try:
          yield itty.next()
        except StopIteration:
          iterators.remove(itty)
  def run(self):
    for output in self.__outputs:
      [mp3 for mp3 in output.output(self.__roundRobin())]

if len(sys.argv) < 3:
  print "No path. e.g. python fillmypod.py /path/to/mp3s /path/to/move/to"
  sys.exit(1)

fmp = FillMyPod()
fmp.addInput(Chronological(sys.argv[1]))
fmp.addOutput(Chain([Printer(), Move(sys.argv[2]), Number()]))
fmp.run()
