#!/bin/bash

#automating the generation of the vina configuration file for a number of protein-ligand complexes
#the script assumes that:
#receptor_name = receptor.pdb
#ligand_name = crystal_ligand.mol2
#and that the names are the same in each directory

for d in */ ; do
	#cleanining dir_name
	dir_name="${d%/*}"

	#assigning some path
	MGLpath=/home/poltix/mgltools_x86_64Linux2_1.5.6/MGLToolsPckgs/AutoDockTools/Utilities24/
	pshpath=/home/poltix/mgltools_x86_64Linux2_1.5.6/bin

	#making output library
	mkdir $dir_name'_DCK/'
	outdir=$dir_name'_DCK/'

	#preparing receptor file removing hydrogens
	awk '$3 !~ /^ *H/' $d"receptor.pdb" > tmp && mv tmp $d"receptor.pdb" &&

	#invoking prepare receptor	
	$pshpath/pythonsh $MGLpath'prepare_receptor4.py' -r $d"receptor.pdb" -o $outdir"receptor.pdbqt" -v - A checkhydrogens -U nphs &&

	#writing prepare receptor in vina configuration file
	echo receptor = $outdir"receptor.pdbqt" > $outdir'vinaConfig'.txt &&
	
	#preparing ligand
	$pshpath/pythonsh $MGLpath'prepare_ligand4.py' -l $d"crystal_ligand.mol2" -o $outdir$dir_name.pdbqt &&	
	#openbabel -imol2 $d"crystal_ligand.mol2" -opdbqt -O $outdir$dir_name.pdbqt &&
	
	#writing ligand in vina configuration file
        echo ligand = $outdir$dir_name.pdbqt >> $outdir'vinaConfig'.txt &&

	#calling a pymol script to generate the searching grid
        python /home/poltix/cage_gen.py $d"receptor.pdb" $d"crystal_ligand.mol2" >> $outdir'vinaConfig'.txt &&

	#writing final stuff like output dir, log location and number of poses
        echo out = $outdir$file.docked.pdbqt >> $outdir'vinaConfig'.txt &&
        echo log = $outdir$file.vina.log >> $outdir'vinaConfig'.txt &&
        echo num_modes = 10 >> $outdir'vinaConfig'.txt
done
