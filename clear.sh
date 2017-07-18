#!/bin/sh

cat /dev/null > ~/.bash_history
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/dmesg
history -c