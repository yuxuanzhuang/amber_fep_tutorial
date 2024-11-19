#!/bin/sh

sander=$AMBERHOME/bin/sander.MPI

echo "Minimising..."
mpirun -np 2 $AMBERHOME/bin/sander.MPI -ng 2 -groupfile min.group

echo "Heating..."
mpirun -np 4 $AMBERHOME/bin/sander.MPI -ng 2 -groupfile heat.group

echo "Pressurising..."
mpirun -np 4 $AMBERHOME/bin/sander.MPI -ng 2 -groupfile press.group

