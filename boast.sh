#!/bin/bash

s=${2:-$RANDOM}
echo "Seed : $s"

M=$1
case $M in
	a) echo "Game : (a) Approaching Keos [Pirate]" ;;
	b) echo "Game : (b) Leaving Keos" ;;
	c) echo "Game : (c) Approaching Keos after 'The Event'" ;;
	d) echo "Game : (d) Leaving Keos for the last time" ;;
	r) echo "Game : RESET" ; M=reset ;;
	*) echo "Use  : $0 mode [seed]     # mode={a,b,c,d} or {r} to reset ; PRNG seed (optional)" ; exit 1 ;;
esac

./scrtest . boastbc $M -i -seed $s
