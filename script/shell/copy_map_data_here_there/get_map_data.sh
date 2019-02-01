#!/bin/bash

file_name='map'
d1=`date '+%Y-%m-%d-%H-%M-%S'`
echo $d1

backup_data='mv '$file_name' '$file_name'_'$d1
echo $backup_data
${backup_data}

copy_data_here='cp /opt/holo/data/'$file_name' . -r'
${copy_data_here}
