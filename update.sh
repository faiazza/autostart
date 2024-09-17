#!/bin/bash
export HOSTNAME=$(cat /etc/hostname)
envsubst <~/autostart/config.json > ~/ccminer/config.json

lscpu | grep Cortex-A53 && service ccminer-a53 restart
lscpu | grep Cortex-A55 && service ccminer-a55 restart

tail -f /var/log/ccminer-a*
