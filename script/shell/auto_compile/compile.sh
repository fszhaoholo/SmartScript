#!/bin/bash

code_path=$1
dir_name=$2
branch_name=$3
build_name=$4
cmake_on_off=$5
debug_on_off=$6

# echo $code_path
# echo $dir_name
# echo $branch_name
# echo $build_name

entry_code_env="cd $code_path$dir_name"
${entry_code_env}

if [ ! -d "$build_name" ];then
    mkdir_build="mkdir $build_name"
    ${mkdir_build}
else
    echo "The directory already exists"
fi

# git_clone_url="git remote -v"
# ${git_clone_url}
# echo $?

entry_build_env="cd $build_name"
${entry_build_env}

if [[ $cmake_on_off =~ "on" ]]; then

    clean_env="git checkout -- .."
    ${clean_env}

    switch_branch="git checkout $branch_name"
    ${switch_branch}

    clean_build_env="rm -rf *"
    ${clean_build_env}

    pull_code="git pull"
    ${pull_code}
    if [[ $debug_on_off =~ "on" ]]; then
        while read line
        do
            if [[ $line =~ .*option\(.*DEBUG.*OFF\) ]] ; then    
                dst_line=$line
                dst_line="$(sed -r 's|OFF|ON|' <<<$dst_line)"
                echo $dst_line
                sed -i "s|$line|$dst_line|g" "../CMakeLists.txt"
            fi

            if [[ $line =~ .*option\(.*TEST.*OFF\) ]] ; then    
                dst_line=$line
                dst_line="$(sed -r 's|OFF|ON|' <<<$dst_line)"
                echo $dst_line
                sed -i "s|$line|$dst_line|g" "../CMakeLists.txt"
            fi

            if [[ $line =~ .*option\(.*SENSORS.*ON\) ]] ; then    
                dst_line=$line
                dst_line="$(sed -r 's|ON|OFF|' <<<$dst_line)"
                echo $dst_line
                sed -i "s|$line|$dst_line|g" "../CMakeLists.txt"
            fi

        done < "../CMakeLists.txt";
    fi

    cmake_cmd="cmake .."
    ${cmake_cmd}
fi

make_cmd="make -j8"
${make_cmd}

if [[ $dir_name =~ "holo_base" ]]  || [[ $dir_name =~ "holo_map" ]] ; then
    install_cmd="sudo make install"
    ${install_cmd}
fi

if [[ $dir_name =~ "holo_cmw" ]] ; then
    install_cmd="sudo -E PYTHONPATH=$PYTHONPATH make install"
    ${install_cmd}
fi


pwd_cmd="pwd"
${pwd_cmd}