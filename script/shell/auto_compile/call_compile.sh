#!/bin/bash

# code path
# code_path="/home/zhaofuxing/zhaofx/workspace/code/code/auto_test/"
code_path="/home/zhaofuxing/zhaofx/workspace/code/test/auto_new_simulator/"

if [ ! -d "$code_path" ];then
    echo "The path is not exist, path = $code_path"
    exit 1
fi

# paramter instruction: module_name git_branch_name build_env_name git_clone_url cmake_on_off debug_on_off
compile_sh_paramter_list=(
    'holo_base,parking_dev_v3,build,ssh://git@out.holomatic.ai:5005/base/holo_base.git,off,off'
    'holo_map,parking_dev_v3,build,ssh://git@out.holomatic.ai:5005/map/holo_map.git,off,off'
    'holo_sensors,parking_dev_v3,build,ssh://git@out.holomatic.ai:5005/vs/holo_sensors.git,off,off'
    'holo_vis,parking_dev_v3,build,ssh://git@out.holomatic.ai:5005/holo/holo_vis.git,off,off'
    'holo_cmw,parking_dev_v3,build,ssh://git@out.holomatic.ai:5005/cmw/holo_cmw.git,off,on'
    'holo_simulator,parking_dev_v3,build,ssh://git@out.holomatic.ai:5005/sim/holo_simulator.git,off,off'
)

for i in "${compile_sh_paramter_list[@]}" ;
do
    array=(${i//,/ })
    module=${array[0]}
    branch_name=${array[1]}
    build_env=${array[2]}
    clone_url=${array[3]}
    cmake_on_off=${array[4]}
    debug_on_off=${array[5]}
    ./clone_code.sh ${code_path} ${module} ${clone_url}
    ./compile.sh ${code_path} ${module} ${branch_name} ${build_env} ${cmake_on_off} ${debug_on_off}
done

echo "Done"
