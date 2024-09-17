#!/bin/bash
service ccminer-a53 stop 
service ccminer-a55 stop
pkill ccminer

export HOSTNAME=$(cat /etc/hostname)
envsubst <~/autostart/config.json > ~/ccminer/config.json

service ccminer-a53 start



tail -f /var/log/ccminer-a*
