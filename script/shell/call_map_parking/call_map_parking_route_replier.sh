#!/bin/bash

source='source /home/holo/zhaofx/workspace/code/holo_cmw/build_parking/devel/setup.bash'
${source}

for((i=1;i<=20;i++))
do   
    cmd='rosservice call /map_parking_replier 15 '$i
    echo $cmd
    ${cmd}
done  

for((i=1;i<=20;i++))
do
    cmd_pick_up='rosservice call /map_parking_replier '$i' 16'
    echo $cmd_pick_up
    ${cmd_pick_up}
done
