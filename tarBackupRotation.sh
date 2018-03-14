#!/bin/bash
####################################
#
# Version: 1.0
# Backup with grandfather-father-son rotation.
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

# Setup variables for the archive filename.
day=$(date +%A)
hostname=$(hostname -s)

# Find which week of the month 1-4 it is.
dayNumber=$(date +%-d)
if (( $dayNumber <= 7 )); then
        weekFile="$hostname-week1.tgz"
elif (( $dayNumber > 7 && $dayNumber <= 14 )); then
        weekFile="$hostname-week2.tgz"
elif (( $dayNumber > 14 && $dayNumber <= 21 )); then
        weekFile="$hostname-week3.tgz"
elif (( $dayNumber > 21 && $dayNumber < 32 )); then
        weekFile="$hostname-week4.tgz"
fi

# Find if the Month is odd or even.
monthNumber=$(date +%m)
month=$(expr $monthNumber % 2)
if [ $month -eq 0 ]; then
        monthFile="$hostname-month2.tgz"
else
        monthFile="$hostname-month1.tgz"
fi

# Create archive filename.
if [ $dayNumber == 1 ]; then
	archiveBackup=$monthFile
elif [ $day != "Saturday" ]; then
        archiveBackup="$hostname-$day.tgz"
else 
	archiveBackup=$weekFile
fi

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
ls -lh $destinationOfBackup/
