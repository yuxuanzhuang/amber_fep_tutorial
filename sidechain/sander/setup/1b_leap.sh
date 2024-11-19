#!/bin/sh
#
# Method 2: setup for a valine maximally mapped to alanine
#           requires a valine template to avoid leap applying standard
#           atom order in VAL
#

tleap=$AMBERHOME/bin/tleap
basedir=leap


$tleap -f - <<_EOF
# load the AMBER force fields
source leaprc.ff14SB
source leaprc.gaff
loadAmberParams frcmod.ionsjc_tip3p

# load force field parameters for BNZ
loadoff $basedir/benz.lib

# a valine template with reordered atoms to map maximally to alanine
loadoff $basedir/MV.lib

# load the coordinates and create the systems
ligand = loadpdb $basedir/bnz.pdb
m1 = loadpdb $basedir/181L_mod.pdb
m2 = loadpdb $basedir/181L_A99V_2.pdb  # contains the MV residue at #99
w = loadpdb $basedir/water_ions.pdb

protein0 = combine {m1 w}
protein1 = combine {m2 w}
complex0 = combine {m1 ligand w}
complex1 = combine {m2 ligand w}

set default nocenter on

# create protein in solution
setBox protein0 vdw {32.71 31.46 43.84}
savepdb protein0 protein.pdb
saveamberparm protein0 protein_V0.parm7 protein_V0.rst7

setBox protein1 vdw {32.71 31.46 43.84}
savepdb protein1 protein.pdb
saveamberparm protein1 protein_V1.parm7 protein_V1.rst7

# create complex in solution
setBox complex0 vdw {32.71 31.46 43.84}
savepdb complex0 complex.pdb
saveamberparm complex0 complex_V0.parm7 complex_V0.rst7

setBox complex1 vdw {32.71 31.46 43.84}
savepdb complex1 complex.pdb
saveamberparm complex1 complex_V1.parm7 complex_V1.rst7

quit
_EOF
