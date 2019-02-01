#!/bin/bash

code_path=$1
dir_name=$2
clone_url=$3

echo $code_path
echo $dir_name
echo $clone_url

if [ ! -d "$code_path$dir_name" ];then
    cd_cmd="cd $code_path"
    ${cd_cmd}

    pwd_cmd="pwd"
    ${pwd_cmd}

    clone_cmd="git clone $clone_url"
    echo $clone_cmd
    ${clone_cmd}
else
    echo "The source code was exist, update code"
    cd_cmd="cd $code_path$dir_name"
    ${cd_cmd}
    
    fetch_cmd="git fetch"
    echo $fetch_cmd
    ${fetch_cmd}

fi