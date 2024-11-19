#!/bin/sh
#
# Run all ligand simulations.  This is mostly a template for the LSF job
# scheduler.
#


. ./windows


mdrun=$AMBERHOME/bin/pmemd.MPI

cd complex

for step in decharge vdw_bonded recharge; do
  cd $step

  for w in $windows; do
    cd $w

    # adapt below for your job scheduler
    module load intel/12.1
    export LD_LIBRARY_PATH=$AMBERHOME/lib:$LD_LIBRARY_PATH

    bsub <<-_EOF
#BSUB -J "ti_complex"
#BSUB -n 8
#BSUB -q your_queue
#BSUB -x
#BSUB -W 02:00
#BSUB -e _ti.err

mpirun -lsf $mdrun -i heat.in -c ti.rst7 -ref ti.rst7 -p ti.parm7 \
  -O -o heat.out -inf heat.info -e heat.en -r heat.rst7 -x heat.nc -l heat.log

mpirun -lsf $mdrun -i ti.in -c heat.rst7 -p ti.parm7 \
  -O -o ti001.out -inf ti001.info -e ti001.en -r ti001.rst7 -x ti001.nc \
     -l ti001.log

_EOF
    # adapt above for your job scheduler

    cd ..
  done

  cd ..
done

