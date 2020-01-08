#!/bin/bash

#executing Vina for each config file
#declaring some variables
vinaPath=/home/poltix/autodock_vina/bin
for d in */ ; do
        $vinaPath/vina --config $d'_DCK/vinaConfig.txt'
done

