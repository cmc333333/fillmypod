import os
import shutil

from mp3 import *

class Printer(object):
  def output(self, iterator):
    for mp3 in iterator:
      print mp3.path
      yield mp3

class Chain(object):
  def __init__(self, elements = []):
    self.__elements = elements
  def addElement(self, element):
    self.__elements.append(element)
  def output(self, iterator):
    mp3s = iter([mp3 for mp3 in iterator])
    for element in self.__elements:
      mp3s = iter([mp3 for mp3 in element.output(mp3s)])
    return mp3s

class Move(object):
  def __init__(self, outputDir):
    self.__dir = outputDir
  def output(self, iterator):
    def mvFile(mp3):
      newPath = os.path.join(self.__dir, mp3.basename)
      os.rename(mp3.path, newPath)
      return Mp3(newPath)
    return map(mvFile, iterator)

class Copy(object):
  def __init__(self, outputDir):
    self.__dir = outputDir
  def output(self, iterator):
    def mvFile(mp3):
      newPath = os.path.join(self.__dir, mp3.basename)
      shutil.copy(mp3.path, newPath)
      return Mp3(newPath)
    return map(mvFile, iterator)

class Limit(object):
  def __init__(self, limit):
    self.__limit = limit
  def output(self, iterator):
    index = 0
    while index < self.__limit:
      try:
        index = index + 1
        yield iterator.next()
      except StopIteration:
        break

class Number(object):
  def output(self, iterator):
    def mvFile(soFar, mp3):
      index = len(soFar) + 1
      newPath = os.path.join(mp3.dirname, str(index) + ".mp3")
      os.rename(mp3.path, newPath)
      soFar.append(Mp3(newPath))
      return soFar
    return reduce(mvFile, iterator, [])
