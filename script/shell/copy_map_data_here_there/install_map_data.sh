#!/bin/bash

file_name='map'
d1=`date '+%Y-%m-%d-%H-%M-%S'`
echo $d1

mkdir_dir='sudo mkdir /opt/holo/data'
echo ${mkdir_dir}
${mkdir_dir}

backup_map_data='sudo mv /opt/holo/data/'$file_name' /opt/holo/data/'$file_name'_'$d1
echo $backup_map_data
${backup_map_data}

copy_data='sudo cp -r '$file_name' /opt/holo/data/'
echo $copy_data
${copy_data}
