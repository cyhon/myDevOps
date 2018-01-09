#!/bin/bash

repo=("finochat"  "pantheon")

for o in ${repo[@]}; do
	cd $o;
	for r in *; do
		cd $r; git rev-list --all --count;
		cd ..;
	done;
	cd ..;
done
