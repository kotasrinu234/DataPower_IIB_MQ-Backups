#!/usr/bin/ksh

# Find the Backup file 

emialalert(){
#!/bin/bash
subject="$1"
body="$2"

# Set recipient email address
recipient="pf_esb_ops@dteenergy.com"

# Send email
echo "$body" | mailx -s "$subject" "$recipient"

# Check if the email was sent successfully
if [ $? -eq 0 ]; then
    echo "Email alert sent successfully."
else
    echo "Failed to send email alert."
fi
}

#backup_results=()
email_body=""
BackupFiles=("ESBI01_*.zip" "ESBI01MQ_*.cfg" "ESBS01_*.zip" "ESBS01MQ_*.cfg" "ESBACC_*.zip" "ESBACCMQ_*.cfg" "ESBMQL01_*.cfg" "ESBMQL02_*.cfg" "PFIIBP01MQ_*.cfg" "PFIIBP01_*.zip" "PFIIBP02MQ_*.cfg" "PFIIBP02_*.zip" "ESBMQACC_*.cfg" "ESBMQST_*.cfg" "ESBMQINT_*.cfg"
"ESBL01MQ_*.cfg" "ESBL01_*.zip" "ESBL02MQ_*.cfg" "ESBL02_*.zip" "PFMQP01_*.cfg" "PFMQP02_*.cfg")
BackupPaths=("/pfbackups/iib/nonprod" "/pfbackups/mq/nonprod" "/pfbackups/iib/load" "/pfbackups/mq/load" "/pfbackups/iib/prod" "/pfbackups/mq/prod")

for ((j=0; j<${#BackupPaths[@]}; j++)); do
    echo "Backup results for path: "${BackupPaths[j]}""
    echo "--------------------------------------------------------"
	backup_results=()
    # Execute backup script for each server
    for ((i=0; i<${#BackupFiles[@]}; i++)); do
        backupfile="${BackupFiles[i]}"
		path="${BackupPaths[j]}"
        result="Success"
        file=$(find "$path" -maxdepth 1 -type f -name "$backupfile")

        if [ -z "$file" ]; then
            echo "No files found for: $backupfile"
        else
            prefix=$(echo "$backupfile" | cut -d'_' -f1)
            backup_results+=("$prefix: $result")
            echo "File found: $file"
        fi
    done
	
	# Construct the email body
	for line in "${backup_results[@]}"; do
		email_body+="$line"$'\n'
	done
	
	if [ $j -eq $((${#BackupPaths[@]} - 1)) ]; then
    # If $j is equal to the index of the last element in the array
    # No need to add the separator line
    echo "This is the last path, no separator line needed"
	else
    # If $j is not equal to the index of the last element in the array
    # Add the separator line
    email_body+="----------------"$'\n'
	fi
	
    echo ""
	echo "$email_body"
done

echo "Final Backup Results:"
echo "--------------------------------------------------------"

echo ""

# Print final email subject
echo "Final Email body:"
echo -e "$email_body"


# Set email subject
subject="Alert: P&F ESB Backup Status : Success"

# Set email body

emialalert "$subject" "$email_body"
