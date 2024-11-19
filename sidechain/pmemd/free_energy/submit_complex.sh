#!/bin/sh
#
# Run all ligand simulations.  This is mostly a template for the LSF job
# scheduler.
#


. ./windows


mdrun=$AMBERHOME/bin/pmemd.MPI

cd complex

for w in $windows; do
  cd $w

  # adapt below for your job scheduler
  module load intel/12.1
  export LD_LIBRARY_PATH=$AMBERHOME/lib:$LD_LIBRARY_PATH

  bsub <<-_EOF
#BSUB -J "ti_complex"
#BSUB -n 24
#BSUB -q your_queue
#BSUB -x
#BSUB -W 06:00
#BSUB -e _ti.err

mpirun -lsf $mdrun -i min.in -c ti.rst7 -ref ti.rst7 -p ti.parm7 \
  -O -o min.out -inf min.info -e min.en -r min.rst7 -l min.log

mpirun -lsf $mdrun -i heat.in -c min.rst7 -ref ti.rst7 -p ti.parm7 \
  -O -o heat.out -inf heat.info -e heat.en -r heat.rst7 -x heat.nc -l heat.log

mpirun -lsf $mdrun -i ti.in -c heat.rst7 -p ti.parm7 \
  -O -o ti001.out -inf ti001.info -e ti001.en -r ti001.rst7 -x ti001.nc \
     -l ti001.log

_EOF
  # adapt above for your job scheduler

  cd ..
done

cd ..

