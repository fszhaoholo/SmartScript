#!/usr/bin/expect

set extension_name [lindex $argv 0]

spawn code --install-extension $extension_name
expect "update" {send "N\n"}
