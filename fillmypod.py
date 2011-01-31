import os
import sys

if len(sys.argv) < 2:
  print "No path. e.g. python fillmypod.py /path/to/mp3s"
  sys.exit(1)

mp3s = []
for parts in os.walk(sys.argv[1]):
  (dirpath, dirnames, filenames) = parts
  for f in filenames:
    (_, ext) = os.path.splitext(f)
    if ext.lower() == ".mp3":
      path = os.path.join(dirpath, f)
      mp3s.append((path, os.path.getmtime(path)))

mp3s.sort(key=lambda mp3:-mp3[1])
for mp3 in mp3s:
  print mp3
