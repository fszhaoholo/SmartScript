#!/bin/bash


path="/home/holo/zhaofx/workspace/code/holo_map/build_auto"
cmd="cd ${path}"
${cmd}


for((i=1;i<=20;i++))
do
#execute="valgrind --log-file=./valgrind_report$i.log --leak-check=full --show-leak-kinds=all --show-reachable=no --track-origins=yes ./test/feature/navigator/test_navigator "
execute="./test/feature/navigator/test_navigator"
${execute}
done

exit 1

test="\ "
echo test

line=$line" "
echo "$line"

code_path="/home/holo/zhaofx/workspace/code/holo_map/build_test/"
entry_build_dir="cd $code_path"
${entry_build_dir}

while read line
do
    if [[ $line =~ .*option\(HOLO_BUILD_DEBUG.*OFF\) ]] ; then    
        dst_line=$line
        dst_line="$(sed -r 's|OFF|ON|' <<<$dst_line)"
        echo $dst_line
        sed -i "s|$line|$dst_line|g" "../CMakeLists.txt"
        break;
    fi
    echo 1
done < "../CMakeLists.txt";
