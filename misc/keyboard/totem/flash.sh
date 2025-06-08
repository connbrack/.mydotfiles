#!/bin/bash

kb="totem"
km="connor"

qmkhome="$(qmk config | sed -n '/home/s/.*=\(.*\)/\1/p')"
fname=$(qmk compile -kb $kb -km $km -n 2>&1 | tr ' ' '\n' | sed -n '/TARGET/s/TARGET=//p').uf2

read -p "Compile firmware (y/n)? " answer
case ${answer:0:1} in
  y | Y) qmk compile -kb $kb -km $km ;;
*) : ;;
esac

cp $qmkhome/$fname /run/media/connor/RPI-RP2/
