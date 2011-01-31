#!/bin/sh
index=1
ls -t -b */*.mp3 | grep -v StarShipSofa | head -n 30 | sort -R | head -n 15 |
(
  while read line
  do
    if test $index -lt 10
    then
      label="0$index"
    else
      label=$index
    fi
    echo $line
    mv "$line" ~/mix/$label.mp3
    index=`expr $index + 1`
  done
);
