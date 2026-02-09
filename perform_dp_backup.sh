#!/bin/bash

# Set variables
DPHOST="$1" # dp-int.dteco.com
DPAPPLIANCE="$2" # dp-int
date=`date '+%Y%m%d'`
NEWDIR="SecureBackup_${date}"
DPUSER='pfdpbackup'
DP_PASSWD='/pfbackups/.dp-p01'
OUTFILE='/pfbackups/out.txt'
fileName="NormalBackup_${date}.zip"


touch /pfbackups/status_file_$date.txt
status_file="/pfbackups/status_file_$date.txt"

# Create a directory for backup
mkdir -p "/pfbackups/${DPAPPLIANCE}/${NEWDIR}"
echo "Folder $NEWDIR created" > "$OUTFILE"

# Execute commands remotely via SSH
echo "$DPUSER
$(cat $DP_PASSWD)
default
co
secure-backup web_mgmt_crypto_cert temporary:///${NEWDIR} off off
copy temporary:///${NEWDIR}/backupmanifest.xml scp://pfesbbackups@lnx1556.dteco.com//pfbackups/${DPAPPLIANCE}/${NEWDIR}/
copy temporary:///${NEWDIR}/cert.tgz scp://pfesbbackups@lnx1556.dteco.com//pfbackups/${DPAPPLIANCE}/${NEWDIR}/
copy temporary:///${NEWDIR}/config.tgz scp://pfesbbackups@lnx1556.dteco.com//pfbackups/${DPAPPLIANCE}/${NEWDIR}/
copy temporary:///${NEWDIR}/local.tgz scp://pfesbbackups@lnx1556.dteco.com//pfbackups/${DPAPPLIANCE}/${NEWDIR}/
copy temporary:///${NEWDIR}/password-map.tgz scp://pfesbbackups@lnx1556.dteco.com//pfbackups/${DPAPPLIANCE}/${NEWDIR}/
copy temporary:///${NEWDIR}/policyframework.tgz scp://pfesbbackups@lnx1556.dteco.com//pfbackups/${DPAPPLIANCE}/${NEWDIR}/
copy temporary:///${NEWDIR}/root.tgz scp://pfesbbackups@lnx1556.dteco.com//pfbackups/${DPAPPLIANCE}/${NEWDIR}/
copy temporary:///${NEWDIR}/sharedcert.tgz scp://pfesbbackups@lnx1556.dteco.com//pfbackups/${DPAPPLIANCE}/${NEWDIR}/
copy temporary:///${NEWDIR}/store.tgz scp://pfesbbackups@lnx1556.dteco.com//pfbackups/${DPAPPLIANCE}/${NEWDIR}/
backup ${fileName}
copy export:///${fileName} scp://pfesbbackups@lnx1556.dteco.com//pfbackups/${DPAPPLIANCE}
" | ssh "$DPUSER@$DPHOST" >> "$OUTFILE"

# Check the output file for any errors
if grep -q "Backup is complete" "$OUTFILE" && \
   { grep -q "Secure backup is complete" "$OUTFILE" || \
     grep -q "Secure backup failed - Cannot read or write to a URL" "$OUTFILE"; }; then
    echo "${DPAPPLIANCE}: SUCCESS" >> "$status_file"

echo "$DPUSER
$(cat $DP_PASSWD)
default
co
delete export:///${fileName}
rmdir temporary:///${NEWDIR}
y
" | ssh "$DPUSER@$DPHOST" >> "$OUTFILE"
else
    echo "${DPAPPLIANCE}: FAILURE" >> "$status_file"
fi
