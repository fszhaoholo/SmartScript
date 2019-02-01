#!/bin/bash

data_base_path=""
map_config_base_path=""

# check data information
cd $data_base_path

while read line
do

    if [[ $line =~ .*option\(.*SENSORS.*ON\) ]] ; then    
    fi

done < "../CMakeLists.txt";

