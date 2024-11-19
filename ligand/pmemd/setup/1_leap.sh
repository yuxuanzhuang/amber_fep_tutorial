#!/bin/sh
#
# Create prmtop and inpcrd for both the ligands in solution and the complex
# in solution.  This is for the vdw+bonded transformation (name assuming that
# all charges of the ligands are turned on/off at the same time).  MD is
# expected to run on these next and the thusly created coordinates will be
# used to create the inputs for the decharging and recharging step (step #4)
# to ensure the same number of molecules are used and also to start from the
# same coordinates.
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
ligands = loadpdb $basedir/bnz_phn.pdb
complex = loadpdb $basedir/181L_mod.pdb
complex = combine {ligands complex}

# create ligands in solution for vdw+bonded transformation
solvatebox ligands TIP3PBOX 12.0 0.75
addions ligands Cl- 0
savepdb ligands ligands_vdw_bonded.pdb
saveamberparm ligands ligands_vdw_bonded.parm7 ligands_vdw_bonded.rst7

# create complex in solution for vdw+bonded transformation
solvatebox complex TIP3PBOX 12.0 0.75
addions complex Cl- 0
savepdb complex complex_vdw_bonded.pdb
saveamberparm complex complex_vdw_bonded.parm7 complex_vdw_bonded.rst7

quit
_EOF
