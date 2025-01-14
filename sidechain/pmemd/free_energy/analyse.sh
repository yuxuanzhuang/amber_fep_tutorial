#!/bin/sh


top=$(pwd)
getdvdl=$top/getdvdl_python3.py

for system in complex protein; do
  cd $system
  result=0.0

  python3 $getdvdl 5 ti001.en [01].* > dvdl.dat
  dG=$(tail -n 1 dvdl.dat | awk '{print $4}')
  echo "dG sum for $system = $dG"

  cd $top
done

