#!/bin/sh
#
# Setup for the free energy simulations: creates and links to the input file as
# necessary.  Two alternative for the de- and recharging step can be used.
#


. ./windows

basedir=../setup
top=$(pwd)
setup_dir=$(cd "$basedir"; pwd)

for system in protein complex; do
  if [ \! -d $system ]; then
    mkdir $system
  fi

  cd $system

  for w in $windows; do
    if [ \! -d $w ]; then
      mkdir $w
    fi

    #method 2:
    #scmask1 = '', scmask2 = ':163@HG=',

    sed -e "s/%L%/$w/" -e "s/%M%/:99/" $top/min.tmpl > $w/min0.in
    sed -e "s/%L%/$w/" -e "s/%M%/:99/" $top/min.tmpl > $w/min1.in
    sed -e "s/%L%/$w/" -e "s/%M%/:99/" $top/heat.tmpl > $w/heat0.in
    sed -e "s/%L%/$w/" -e "s/%M%/:99/" $top/heat.tmpl > $w/heat1.in
    sed -e "s/%L%/$w/" -e "s/%M%/:99/" $top/prod.tmpl > $w/ti0.in
    sed -e "s/%L%/$w/" -e "s/%M%/:99/" $top/prod.tmpl > $w/ti1.in

    (
      cd $w
      ln -sf $setup_dir/${system}_V0.parm7 V0.parm7
      ln -sf $setup_dir/${system}_V0.rst7  V0.rst7
      ln -sf $setup_dir/${system}_V1.parm7 V1.parm7
      ln -sf $setup_dir/${system}_V1.rst7  V1.rst7
      ln -sf $top/min.group ../min.group
      ln -sf $top/heat.group ../heat.group
      ln -sf $top/prod.group ../ti001.group
    )
  done

  cd $top
done

