BKPDIR=("/pfbackups/dp-dev" "/pfbackups/dp-int" "/pfbackups/dp-st" "/pfbackups/dp-acc" "/pfbackups/dp-l01" "/pfbackups/dp-l02" "/pfbackups/dp-l03" "/pfbackups/dp-l04" "/pfbackups/dp-pf-p01" "/pfbackups/dp-pf-p02" "/pfbackups/dp-pf-p03" "/pfbackups/dp-pf-p04" "/pfbackups/ESBMQINT" "/pfbackups/ESBMQST" "/pfbackups/ESBMQACC" "/pfbackups/ESBMQL01" "/pfbackups/ESBMQL02" "/pfbackups/PFMQP01" "/pfbackups/PFMQP02" "/pfbackups/ESBI01" "/pfbackups/ESBS01" "/pfbackups/ESBACC" "/pfbackups/ESBL01" "/pfbackups/ESBL02" "/pfbackups/PFIIBP01" "/pfbackups/PFIIBP02")
Retention=6
for ((j=0; j<${#BKPDIR[@]}; j++)); do
		find ${BKPDIR[j]} -mtime +$Retention -exec rm -r {} \;
done

