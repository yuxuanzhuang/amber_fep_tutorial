#!/bin/sh

pmemd=$AMBERHOME/bin/pmemd.cuda
prmtop=../ligands_vdw_bonded.parm7


echo "Minimising..."
$pmemd \
  -i min.in -p $prmtop -c ../ligands_vdw_bonded.rst7 \
  -ref ../ligands_vdw_bonded.rst7 \
  -O -o min.out -e min.en -inf min.info -r min.rst7 -l min.log

echo "Heating..."
$pmemd \
  -i heat.in -p $prmtop -c min.rst7 -ref ../ligands_vdw_bonded.rst7 \
  -O -o heat.out -e heat.en -inf heat.info -r heat.rst7 -x heat.nc -l heat.log

echo "Pressurising..."
$pmemd \
  -i press.in -p $prmtop -c heat.rst7 -ref heat.rst7 \
  -O -o press.out -e press.en -inf press.info -r press.rst7 -x press.nc \
     -l press.log

