#!/usr/bin/expect

set ssh_name [lindex $argv 0]
puts $ssh_name

set password [lindex $argv 1]
puts $password

set dir_name [lindex $argv 2]
puts $dir_name


set d1 [exec date +%Y-%m-%d-%H-%M-%S]
puts $d1

set timeout 1

#copy map data from here to ssh:/tmp/map_time
spawn scp -o StrictHostKeyChecking=no -P 22 -r map ${ssh_name}:/tmp/${dir_name}_${d1}
expect {
"(yes/no)?" {
send "yes\n"
expect "*password*:" { send "$password\r"}
}
"*password*:" {
send "$password\r"
}
}

#login ssh server
spawn ssh -p 22 ${ssh_name}
expect "*password*:" {send "$password\r"}

#backup map data
expect "#*"  
send "sudo mv /opt/holo/data/${dir_name} /opt/holo/data/${dir_name}_${d1} \r"
expect "*password*:" { send "$password\r"}

#copy data to /opt/holo/data/map
expect "#*"  
send "sudo cp -r /tmp/${dir_name}_${d1} /opt/holo/data/${dir_name} \r"
expect "*password*:" { send "$password\r"}

# verify the result
expect "#*"
send "ll /opt/holo/data/${dir_name} \r"

#exit from ssh server
expect "#*"  
send "exit \r"   

# interact
# expect "100%"
# expect eof
