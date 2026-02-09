date=`date '+%Y%m%d'`
status_file="/pfbackups/status_file_$date.txt"
sh /pfbackups/perform_dp_backup.sh dp-dev.dteco.com dp-dev

echo -e "\n" >> "$status_file"

sh /pfbackups/perform_dp_backup.sh dp-int.dteco.com dp-int
sh /pfbackups/perform_ace_backup.sh ESBI01 esbint aix10020
sh /pfbackups/perform_mq_backup.sh ESBMQINT mqmint lnx1359

echo -e "\n" >> "$status_file"

sh /pfbackups/perform_dp_backup.sh dp-st.dteco.com dp-st
sh /pfbackups/perform_ace_backup.sh ESBS01 esbst aix10020
sh /pfbackups/perform_mq_backup.sh ESBMQST mqmst lnx1359

echo -e "\n" >> "$status_file"

sh /pfbackups/perform_dp_backup.sh dp-acc.dteco.com dp-acc
sh /pfbackups/perform_ace_backup.sh ESBACC esbacc aix10020
sh /pfbackups/perform_mq_backup.sh ESBMQACC mqmacc lnx1359

echo -e "\n" >> "$status_file"

sh /pfbackups/perform_dp_backup.sh dp-l01.dteco.com dp-l01
sh /pfbackups/perform_dp_backup.sh dp-l02.dteco.com dp-l02
sh /pfbackups/perform_dp_backup.sh dp-l03.dteco.com dp-l03
sh /pfbackups/perform_dp_backup.sh dp-l04.dteco.com dp-l04
sh /pfbackups/perform_ace_backup.sh ESBL01 esbadm aix10018
sh /pfbackups/perform_ace_backup.sh ESBL02 esbadm aix10019
sh /pfbackups/perform_mq_backup.sh ESBMQL01 mqm Lnx1400
sh /pfbackups/perform_mq_backup.sh ESBMQL02 mqm lnx1360

echo -e "\n" >> "$status_file"

sh /pfbackups/perform_dp_backup.sh dp-pf-p01.dteco.com dp-pf-p01
sh /pfbackups/perform_dp_backup.sh dp-pf-p02.dteco.com dp-pf-p02
sh /pfbackups/perform_dp_backup.sh dp-pf-p03.dteco.com dp-pf-p03
sh /pfbackups/perform_dp_backup.sh dp-pf-p04.dteco.com dp-pf-p04
sh /pfbackups/perform_ace_backup.sh PFIIBP01 esbadm aix20029
sh /pfbackups/perform_ace_backup.sh PFIIBP02 esbadm aix20031
sh /pfbackups/perform_mq_backup.sh PFMQP01 mqm aix20033
sh /pfbackups/perform_mq_backup.sh PFMQP02 mqm aix20035

if grep -q "FAILURE" "$status_file"; then
    subject="P&F ESB Backup Status : FAILURE"
else
    subject="P&F ESB Backup Status : SUCCESS"
fi

recipient="PF_ESB_OPS@dteenergy.com"

message=$(cat "$status_file")

# Send email
echo "$message" | mail -s "$subject" "$recipient"

# Removing the status file
rm -f /pfbackups/status_file_$date.txt

sh /pfbackups/Delete_Old_Backups.sh

