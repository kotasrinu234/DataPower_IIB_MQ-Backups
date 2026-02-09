#!/bin/bash

# Define variables
recipient="srinu.kota@dteenergy.com"
subject="P&F ESB Backup Status : SUCCESS"
status_file="/pfbackups/status_file.txt"

# Read the content of the status file
message=$(cat "$status_file")

# Send email
echo "$message" | mail -s "$subject" "$recipient"

# Clear the content of the status file
echo "" > "$status_file"


