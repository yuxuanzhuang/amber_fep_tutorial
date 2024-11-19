#!/bin/sh
#
# Run all ligand simulations.  This is mostly a template for the LSF job
# scheduler.
#


. ./windows

cd ligands

for step in decharge vdw_bonded recharge; do
  cd $step

  for w in $windows; do
    cd $w

    # adapt below for your job scheduler
    module load intel/12.1
    export LD_LIBRARY_PATH=$AMBERHOME/lib:$LD_LIBRARY_PATH

    bsub <<-_EOF
#BSUB -J "ti_ligands"
#BSUB -n 8
#BSUB -q your_queue
#BSUB -x
#BSUB -W 01:00
#BSUB -e _ti.err

# the heating step is not needed if the MD step in the setup step has been done
#mpirun -lsf -np 8 $AMBERHOME/bin/sander.MPI -ng 2 -groupfile ../heat.group

mpirun -lsf -np 8 $AMBERHOME/bin/sander.MPI -ng 2 -groupfile ../ti001.group

_EOF
    # adapt above for your job scheduler

    cd ..
  done

  cd ..
done

