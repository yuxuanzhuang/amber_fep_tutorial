#!/bin/sh


module load intel/12.1
export LD_LIBRARY_PATH=$AMBERHOME/lib:$LD_LIBRARY_PATH

pmemd=$AMBERHOME/bin/pmemd.MPI
mpirun="mpirun -lsf"
prmtop=../complex_vdw_bonded.parm7

# adapt below for your job scheduler
bsub <<_EOF
#BSUB -J "prepare_complex"
#BSUB -n 8
#BSUB -q your_queue
#BSUB -x
#BSUB -W 01:00
#BSUB -e _ti.err

$mpirun $pmemd \
  -i min.in -p $prmtop -c ../complex_vdw_bonded.rst7 \
  -ref ../complex_vdw_bonded.rst7 \
  -O -o min.out -e min.en -inf min.info -r min.rst7 -l min.log

$mpirun $pmemd \
  -i heat.in -p $prmtop -c min.rst7 -ref ../complex_vdw_bonded.rst7 \
  -O -o heat.out -e heat.en -inf heat.info -r heat.rst7 -x heat.nc -l heat.log

$mpirun $pmemd \
  -i press.in -p $prmtop -c heat.rst7 -ref heat.rst7 \
  -O -o press.out -e press.en -inf press.info -r press.rst7 -x press.nc \
     -l press.log
_EOF

