#!/bin/sh


top=$(pwd)
getdvdl=$top/getdvdl.py

for system in complex protein; do
  cd $system
  result=0.0

  python $getdvdl 5 ti001_0.en [01].* > dvdl.dat
  dG=$(tail -n 1 dvdl.dat | awk '{print $4}')
  echo "dG sum for $system = $dG"

  cd $top
done

