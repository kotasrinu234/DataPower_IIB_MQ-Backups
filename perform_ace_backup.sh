#!/bin/bash

# Define variables
NODE=$1
USER=$2
HOST=$3
date=`date '+%Y%m%d'`
BackupFile=$NODE"_"$date

touch /pfbackups/status_file_$date.txt
status_file="/pfbackups/status_file_$date.txt"

ssh $USER@$HOST "rm -f /tmp/${BackupFile}".cfg"; . ./.profile;  dmpmqcfg -m $NODE > /tmp/${BackupFile}".cfg""
if [ $? == 0 ]
then 
	scp $USER@$HOST:/tmp/${BackupFile}".cfg" /pfbackups/${NODE}
	if [ $? == 0 ]
	then
		echo "MQ BACKUP SUCCESS"
	else 
		echo "${NODE}"_MQ": FAILURE" >> "$status_file"
	fi
else
	echo "${NODE}"_MQ": FAILURE" >> "$status_file"
fi
ssh $USER@$HOST "rm -f /tmp/${BackupFile}".cfg""



ssh $USER@$HOST "rm -f /tmp/${BackupFile}".zip"; . ./.profile; mqsibackupbroker $NODE -f -d /tmp -a ${BackupFile}".zip""
if [ $? == 0 ]
then 
	scp $USER@$HOST:/tmp/${BackupFile}".zip" /pfbackups/${NODE}
	if [ $? == 0 ]
	then
		echo "${NODE}: SUCCESS" >> "$status_file"
	else 
		echo "${NODE}: FAILURE" >> "$status_file"
	fi
else
	echo "${NODE}: FAILURE" >> "$status_file"
fi
ssh $USER@$HOST "rm -f /tmp/${BackupFile}".zip""

