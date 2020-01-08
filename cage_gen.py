# -*- coding: utf-8 -*-
from __future__ import print_function
import sys
import pymol
from pymol import cmd
from pymol import stored
from chempy import cpv
from os import path
pymol.finish_launching(['pymol', '-cq'])

def centroid(selection='all', center=0, quiet=1):

    model = cmd.get_model(selection)
    nAtom = len(model.atom)

    centroid = cpv.get_null()

    for a in model.atom:
        centroid = cpv.add(centroid, a.coord)
    centroid = cpv.scale(centroid, 1. / nAtom)

    if not int(quiet):
        print(' centroid: [%8.3f,%8.3f,%8.3f]' % tuple(centroid))

    if int(center):
        cmd.alter_state(1, selection, "(x,y,z)=sub((x,y,z), centroid)",
                        space={'centroid': centroid, 'sub': cpv.sub})

    return centroid


cmd.feedback("disable","all","actions")
cmd.feedback("disable","all","results")
cmd.feedback("disable","all","warnings actions")

protName= path.basename(sys.argv[1])
ligName = path.basename(sys.argv[2])
#cmd.load('/home/gabriele/Documenti/rdkitDocking/all/aa2ar/receptor.pdb', protName)
#cmd.load('/home/gabriele/Documenti/rdkitDocking/all/aa2ar/crystal_ligand.mol2', ligName)
cmd.load(sys.argv[1], protName)
cmd.load(sys.argv[2], ligName)
#(comX, comY, comZ) = centroid(ligName)
(comX, comY, comZ) = centroid('receptor')
((maxX, maxY, maxZ), (minX, minY, minZ)) = cmd.get_extent(protName)
#print((maxX, maxY, maxZ), (minX, minY, minZ))
print('center_x = %8.4f\ncenter_y = %8.4f\ncenter_z = %8.4f\nsize_x =  %8.4f\nsize_y =  %8.4f\nsize_z = %8.4f\n' % (comX, comY, comZ, abs(maxX-minX), abs(maxY-minY), abs(maxZ-minZ)))
