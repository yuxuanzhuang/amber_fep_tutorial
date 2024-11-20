# Amber Tutorial - Small Molecule Binding to T4-Lysozyme L99A

This repository contains files and scripts for the Amber tutorial on small molecule binding to T4-lysozyme L99A. The tutorial follows the steps outlined in the official Amber documentation:

[Amber Tutorial: Small Molecule Binding to T4-Lysozyme L99A](https://ambermd.org/tutorials/advanced/tutorial9/index.html#home)

Modifications for Compatibility with Amber20

This version of the tutorial includes updates and fixes to ensure smooth usage with Amber20. Key modifications are as follows:
- Updated Input File Syntax:
  - Replaced deprecated bar_l_min, bar_l_max, etc., with mbar_lambda and mbar_states in .in files for the free energy calculations.
 
- Force Field Updates:
  - Updated tleap inputs to use amber.ff19SB for protein preparation.
 
- GPU-Accelerated pmemd
  - Configured scripts to use local `pmemd.cuda` for simulations.
 
- Python 3 Compatibility:
  - Updated analysis scripts to use Python 3 for modern compatibility.
 
- ParmEd Updates:
  - Separate ParmEd Installation: Ensure ParmEd is installed independently.
  - Patch for tiMerge Command: Applied fixes to address the tiMerge functionality issue in ParmEd with ff19SB. Details can be found [here](https://github.com/ParmEd/ParmEd/issues/1169#issuecomment-962680319)
