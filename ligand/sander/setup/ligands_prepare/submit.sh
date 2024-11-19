#!/bin/sh


module load intel/12.1
export LD_LIBRARY_PATH=$AMBERHOME/lib:$LD_LIBRARY_PATH

# adapt below for your job scheduler
bsub <<_EOF
#BSUB -J "prepare_ligands"
#BSUB -n 4
#BSUB -q your_queue
#BSUB -x
#BSUB -W 01:00
#BSUB -e _ti.err

mpirun -lsf -np 2 $AMBERHOME/bin/sander.MPI -ng 2 -groupfile min.group

mpirun -lsf -np 4 $AMBERHOME/bin/sander.MPI -ng 2 -groupfile heat.group

mpirun -lsf -np 4 $AMBERHOME/bin/sander.MPI -ng 2 -groupfile press.group

_EOF

