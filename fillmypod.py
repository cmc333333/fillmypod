import os
import sys

class DirBased(object):
  def __init__(self, path):
    self.mp3s = []
    for parts in os.walk(path):
      (dirpath, dirnames, filenames) = parts
      for f in filenames:
        (_, ext) = os.path.splitext(f)
        if ext.lower() == ".mp3":
          path = os.path.join(dirpath, f)
          self.mp3s.append((path, os.path.getmtime(path)))
  def iterator(self):
    return self.mp3s.__iter__()

class Random(object):
  def __init__(self, path):
    self.__dir = DirBased(path)
    import random
    random.shuffle(self.__dir.mp3s)
  def iterator(self):
    return self.__dir.iterator()

class Chronological(object):
  def __init__(self, path):
    self.__dir = DirBased(path)
    self.__dir.mp3s.sort(key=lambda mp3:mp3[1])
  def iterator(self):
    return self.__dir.iterator()

if len(sys.argv) < 2:
  print "No path. e.g. python fillmypod.py /path/to/mp3s"
  sys.exit(1)

for filename in Random(sys.argv[1]).iterator():
  print filename

for filename in Chronological(sys.argv[1]).iterator():
  print filename
