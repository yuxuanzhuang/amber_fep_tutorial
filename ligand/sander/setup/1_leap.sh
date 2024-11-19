#!/bin/sh
#
# Create prmtop and inpcrd for both the ligands in solution and the complex
# in solution. This is for the initial state.
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

# load the coordinates and create the complex
bnz = loadpdb $basedir/bnz.pdb
protein = loadpdb $basedir/181L_mod.pdb
complex = combine {bnz protein}

# create benzene in solution
solvatebox bnz TIP3PBOX 12.0 0.75
addions bnz Cl- 0
savepdb bnz ligands0.pdb
saveamberparm bnz ligands0.parm7 ligands0.rst7

# create benzene-complex in solution
solvatebox complex TIP3PBOX 12.0 0.75
addions complex Cl- 0
savepdb complex complex0.pdb
saveamberparm complex complex0.parm7 complex0.rst7

quit
_EOF
