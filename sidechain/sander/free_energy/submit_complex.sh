#!/bin/sh
#
# Run all ligand simulations.  This is mostly a template for the LSF job
# scheduler.
#


. ./windows


mdrun=$AMBERHOME/bin/sander.MPI

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

mpirun -np 2 $mdrun -ng 2 -groupfile ../min.group
mpirun -lsf $mdrun -ng 2 -groupfile ../heat.group
mpirun -lsf $mdrun -ng 2 -groupfile ../ti001.group
_EOF
  # adapt above for your job scheduler

  cd ..
done

cd ..

