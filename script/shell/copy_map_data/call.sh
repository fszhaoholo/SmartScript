#!/bin/bash

# directory name , general name is map, e.x path is "/opt/holo/data/map"
dir_name="map"

# ip list ,used for ssh connect, separate by backspace
#ips=(holo@192.168.20.10 holoparking@192.168.3.7 holobeacon@192.168.3.8 rootserver@192.168.2.10 holo-blockserver@192.168.2.11 holo-blockserver1@192.168.2.12 holo@192.168.2.13)
#ips=(holo@192.168.3.145)
ips=(holo@192.168.20.10  block_server_1@192.168.20.11 block_server_2@192.168.20.12)

# password list, separate by backspace, note the backspace
# passwords=(" " " " " " " ")

#because of the password is backspace , so so so ,it is so XXX 
password=$password" "

length=${#ips[@]}

for (( i = 0; i < $length; i ++ ))
do   
    ip=${ips[i]}
    # password=${passwords[i]}
    ./scp.sh $ip "$password" $dir_name
done   
echo "102-100＝0"

