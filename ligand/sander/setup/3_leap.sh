#!/bin/sh
#
# Create prmtop and inpcrd for both the ligands in solution and the complex
# in solution. This is for the final state.  Coordinates are taken from the
# initial state.
#

tleap=$AMBERHOME/bin/tleap
basedir=leap


$tleap -f - <<_EOF
# load the AMBER force fields
source leaprc.ff14SB
source leaprc.gaff
loadAmberParams frcmod.ionsjc_tip3p

# load force field parameters for BNZ and PHN
loadoff $basedir/benz.lib
loadoff $basedir/phen.lib

# create phenol in solution
phn0 = loadpdb ligands0_phn.pdb
ligand = loadpdb ligands0_solvated.pdb
ligand = combine {phn0 ligand}

setbox ligand vdw
savepdb ligand ligands1.pdb
saveamberparm ligand ligands1.parm7 ligands1.rst7

# create phenol-complex in solution
phn1 = loadpdb complex0_phn.pdb
complex = loadpdb complex0_solvated.pdb
complex = combine {phn1 complex}

setbox complex vdw
savepdb complex complex1.pdb
saveamberparm complex complex1.parm7 complex1.rst7

quit
_EOF
