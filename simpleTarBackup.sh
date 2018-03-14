#!/bin/bash
####################################
#
# Version: 1.0
# 
# Author: Emil Yavorov Zahariev
# 
# Creating test tree:
#
# for i in 0 1 2; do mkdir -p /tmp/data$i/sub$i; echo foo > /tmp/data$i/sub$i/foo; done
#
####################################

# What to backup. 
stuffToBackUp="/tmp/data*"
# Exclude dirs separated with a space. 
#The bacup direcotory itself should always be excluded from backup as this will cause an infinate loop.
EXCLD='/tmp/data/sub1 /tmp/data2/sub1'

# Where to backup to.
destinationOfBackup="/tmp"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archiveBackup="$hostname-$day.tar.gz"

# Print start status message.
echo "Backing up $stuffToBackUp to $destinationOfBackup/$archiveBackup"
date
echo

# Backup the files using tar.
tar -X <(for i in ${EXCLD}; do echo $i; done) -czf $destinationOfBackup/$archiveBackup $stuffToBackUp

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $destinationOfBackup to check file sizes.
ls -lh $destinationOfBackup

