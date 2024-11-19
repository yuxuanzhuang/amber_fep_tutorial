# create a template for VAL maximally mapped to ALA
# NOTE: force field dependent, here FF14SB

source leaprc.ff14SB
MV = loadmol2 MV.mol2

set MV    restype   protein
set MV    head      MV.1.N
set MV    tail      MV.1.C
set MV.1  connect0  MV.1.N
set MV.1  connect1  MV.1.C

saveoff MV MV.lib

quit
