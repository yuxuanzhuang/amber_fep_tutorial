#!/bin/sh
#
# Perform minimisation and MD simulation to prepare the simulation box
# for TI simulation. This is done primarily to adjust the density of the
# system because leap will create a water box with too low a density.
#

basedir=$(pwd)

for dir in ligands_prepare complex_prepare; do
  echo "Running MD in $dir"
  cd $dir
  ./run_all_md.sh
  #./submit.sh
  cd $basedir
done
