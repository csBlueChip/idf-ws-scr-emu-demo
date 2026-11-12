#!/bin/bash

M=${1^^}
case $M in
	A|B|C|D|R) ;;
	*) echo "Use  : $0 mode [seed]     # mode={a,b,c,d} or {r} to reset ; PRNG seed (optional)" ; exit 1 ;;
esac

s=${2:-$RANDOM}
echo "Seed : $s"

[ -x scrtest ] || {
	echo "-----------------------------------------"
	echo "- first time build"
	echo "-----------------------------------------"
	make all
	echo "-----------------------------------------"
	echo ""
}

echo "==============================================================="
echo " Boasts and Retorts : Greek Mythos Edition"
echo " Swashbuckling egocentricity with The Tyrrhenian Pirates"
echo "==============================================================="
case $M in
	A) echo " Game Mode : (a) Approaching Keos before 'The Event' [Pirate]" ;;
	B) echo " Game Mode : (b) Leaving Keos [Pirate]" ;;
	C) echo " Game Mode : (c) Approaching Keos after 'The Event' [Pirate]" ;;
	D) echo " Game Mode : (d) Leaving Keos for the last time [Captain]" ;;
	R) echo " Game Reset..." ; M=reset ;;
esac
echo "==============================================================="
./scrtest . boastbc $M -i -seed $s
