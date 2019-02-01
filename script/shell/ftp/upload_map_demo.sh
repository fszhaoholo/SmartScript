#!/bin/bash

d1=`date '+%Y-%m-%d-%H-%M-%S'`
echo $d1

data="demo"
back_dir=".."
data_dir="Map/demo"
backup_dir="/Map/IndexedMapData"

backup_name=""

# get version file name
cd $data
for file in $(ls *)
do
    if [[ $file =~ DB-.* ]];
    then 
        backup_name=$file
        echo $file
    fi
done

if [[ ! $backup_name =~ "" ]];
then
    echo "Please check whether the directory($data) has version file."
    exit 0
fi
cd $back_dir

# backup data and upload new data
ftp -v -n ftp.holomatic.ai<<EOF 
user holo 1709heduo
binary 
hash 
rename $data_dir $backup_dir/map_${backup_name}_\($d1\)
mkdir $data_dir
lcd ${data}
cd ${data_dir}
prompt 
mput * 
bye 
#here document 
EOF 
echo "commit to ftp successfully"

