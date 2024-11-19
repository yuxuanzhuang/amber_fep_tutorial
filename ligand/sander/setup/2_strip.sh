#!/bin/sh
#
# Use cpptraj to extract the coordinates for the ligand and the
# rest of the system (complex: protein+water, ligands:water only)
#

cpptraj=$AMBERHOME/bin/cpptraj

for s in ligands0 complex0; do
  $cpptraj -p ${s}.parm7 <<_EOF
trajin ${s}.rst7

# remove the ligand and keep the rest
strip ":1"
outtraj ${s}_solvated.pdb onlyframes 1

# keep only first ligand without hydrogens
unstrip
strip ":1@H= | :2-999999"
outtraj ${s}_bnz.pdb onlyframes 1
_EOF

# ugly kludge: works only in this specific case
sed -e 's/ BNZ / PHN /' ${s}_bnz.pdb > ${s}_phn.pdb
done
