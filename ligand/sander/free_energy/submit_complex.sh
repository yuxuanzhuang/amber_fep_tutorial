#!/bin/sh
#
# Run all complex simulations.  This is mostly a template for the LSF job
# scheduler.
#


. ./windows

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
#BSUB -n 16
#BSUB -q your_queue
#BSUB -x
#BSUB -W 04:00
#BSUB -e _ti.err

# the heating step is not needed if the MD step in the setup step has been done
#mpirun -lsf -np 16 $AMBERHOME/bin/sander.MPI -ng 2 -groupfile ../heat.group

mpirun -lsf -np 16 $AMBERHOME/bin/sander.MPI -ng 2 -groupfile ../ti001.group

_EOF
    # adapt above for your job scheduler

    cd ..
  done

  cd ..
done

