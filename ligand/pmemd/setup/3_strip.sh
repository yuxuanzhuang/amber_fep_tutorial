#!/bin/sh
#
# Use cpptraj to extract the individual ligands and the rest of the system
# (complex: protein+water, ligands:water only).  This is done to get the
# coordinates and keep the same number of molecules for the setup of the
# subsequent de- and recharging steps.
#

cpptraj=$AMBERHOME/bin/cpptraj

for s in ligands complex; do
  if [ -f ${s}_prepare/press.rst7 ]; then
    cp ${s}_vdw_bonded.rst7 ${s}_vdw_bonded.rst7.leap
    cp ${s}_prepare/press.rst7 ${s}_vdw_bonded.rst7
  fi

  $cpptraj -p ${s}_vdw_bonded.parm7 <<_EOF
trajin ${s}_prepare/press.rst7

# remove the two ligands and keep the rest
strip ":1,2"
outtraj ${s}_solvated.pdb onlyframes 1

# extract the first ligand
unstrip
strip ":2-999999"
outtraj ${s}_bnz.pdb onlyframes 1

# extract the second ligand
unstrip
strip ":1,3-999999"
outtraj ${s}_phn.pdb onlyframes 1
_EOF
done
