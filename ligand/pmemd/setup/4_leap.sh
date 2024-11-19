#!/bin/sh
#
# Create the prmtop and inpcrd files for the decharging and recharging steps.
# The coordinates are taken from the previous vdw+bonded step.
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

# coordinates for solvated ligands as created previously by MD
lsolv = loadpdb ligands_solvated.pdb
lbnz = loadpdb ligands_bnz.pdb
lphn = loadpdb ligands_phn.pdb

# coordinates for complex as created previously by MD
csolv = loadpdb complex_solvated.pdb
cbnz = loadpdb complex_bnz.pdb
cphn = loadpdb complex_phn.pdb

# decharge transformation
decharge = combine {lbnz lbnz lsolv}
setbox decharge vdw
savepdb decharge ligands_decharge.pdb
saveamberparm decharge ligands_decharge.parm7 ligands_decharge.rst7

decharge = combine {cbnz cbnz csolv}
setbox decharge vdw
savepdb decharge complex_decharge.pdb
saveamberparm decharge complex_decharge.parm7 complex_decharge.rst7

# recharge transformation
recharge = combine {lphn lphn lsolv}
setbox recharge vdw
savepdb recharge ligands_recharge.pdb
saveamberparm recharge ligands_recharge.parm7 ligands_recharge.rst7

recharge = combine {cphn cphn csolv}
setbox recharge vdw
savepdb recharge complex_recharge.pdb
saveamberparm recharge complex_recharge.parm7 complex_recharge.rst7

quit
_EOF
