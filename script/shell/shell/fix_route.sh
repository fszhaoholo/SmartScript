#!/bin/sh
sudo route add default netmask 0.0.0.0 gw 192.168.1.1 metric 99 dev eth1

