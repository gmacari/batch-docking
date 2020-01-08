# batch-docking
A simple set of bash and python2 scripts meant to be used to automate the preparation and the execution of molecular docking for libraries of protein-ligand complexes.

The preparation of the files is performed using AutoDockTools and PyMol module for python.

MGLTools and Vina path needed to be set.

By default the search cage is centered around the ligand. However, it is available, commented, a line to draw a more generic grid centered insted on the protein's center of mass.

Lastly, the name of the ligand and the protein need to be set accordingly to ones needs. 
