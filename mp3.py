import os

class Mp3(object):
  def __init__(self, path):
    self.path = path
    self.mtime = os.path.getmtime(path)
    self.basename = os.path.basename(path)
    self.dirname = os.path.dirname(path)
