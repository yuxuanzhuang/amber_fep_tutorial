#!/bin/sh
#
# Setup for the free energy simulations: creates and links to the input file as
# necessary.  Two alternative for the de- and recharging step can be used.
#


. ./windows

# partial removal/addition of charges: softcore atoms only
crg0=":1@H6"
crg1=":1@O1,H6"

# complete removal/addition of charges
#crg0=":1"
#crg1=":1"

decharge0=" ifsc = 0,"
decharge1=" ifsc = 0, crgmask = '$crg0',"
vdw_bonded0=" ifsc=1, scmask=':1@H6', crgmask='$crg0'"
vdw_bonded1=" ifsc=1, scmask=':1@O1,H6', crgmask='$crg1'"
recharge0=" ifsc = 0, crgmask = '$crg1',"
recharge1=" ifsc = 0,"

basedir=../setup
top=$(pwd)
setup_dir=$(cd "$basedir"; pwd)

for system in ligands complex; do
  if [ \! -d $system ]; then
    mkdir $system
  fi

  cd $system

  for step in decharge vdw_bonded recharge; do
    if [ \! -d $step ]; then
      mkdir $step
    fi

    cd $step

    for w in $windows; do
      if [ \! -d $w ]; then
        mkdir $w
      fi

      FE0=$(eval "echo \${${step}0}")
      FE1=$(eval "echo \${${step}1}")

      sed -e "s/%L%/$w/" -e "s/%FE%/$FE0/" $top/heat.tmpl > $w/heat0.in
      sed -e "s/%L%/$w/" -e "s/%FE%/$FE1/" $top/heat.tmpl > $w/heat1.in

      sed -e "s/%L%/$w/" -e "s/%FE%/$FE0/" $top/prod.tmpl > $w/ti0.in
      sed -e "s/%L%/$w/" -e "s/%FE%/$FE1/" $top/prod.tmpl > $w/ti1.in

      (
        cd $w
        ln -sf $setup_dir/${system}0.parm7 ti0.parm7
        ln -sf $setup_dir/${system}1.parm7 ti1.parm7
        ln -sf $setup_dir/${system}_prepare/press0.rst7 ti0.rst7
        ln -sf $setup_dir/${system}_prepare/press1.rst7 ti1.rst7
        ln -sf $top/heat_$step.group ../heat.group
        ln -sf $top/prod_$step.group ../ti001.group
      )
    done

    cd ..
  done

  cd $top
done

