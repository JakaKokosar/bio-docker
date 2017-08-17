#!/bin/bash

path='python3 -m server_update.'
start_time=$SECONDS
[ -e update_log.txt ] && rm update_log.txt

scripts=('updateTaxonomy' 'updateNCBI_geneinfo' 'updateGEO' 'updateGO' 'updatemiRNA' 'updateDictyBase' 'updateHomoloGene' 'updateOMIM' 'updatePPI' 'updateSTRING' 'updateGeneSets')
#scripts=('updateTaxonomy' 'updateNCBI_geneinfo' 'updateGEO' 'updateGO' 'updateDictyBase' 'updateHomoloGene' 'updateOMIM')   
for fname in "${scripts[@]}"
do
    echo "Start $fname"
    stderr=$($path$fname 2>&1>/dev/null) # exectute update script and store stderr to variable
    exit_code=$?
    if [ $exit_code -ne 0 ]; then  
        if [ $exit_code -eq 10 ]; then
            echo "$fname all files are up to date!" >> update_log.txt
        else
            echo "$stderr" >> update_log.txt
        fi 
    else
        elapsed_time=$(($SECONDS - $start_time))
        printf "%s ended successfully. Elapsed time: %02dh:%02dm:%02ds\n" $fname $(($elapsed_time/3600)) $(($elapsed_time%3600/60)) $(($elapsed_time%60)) >> update_log.txt
    fi 
    echo "Exit $fname"
done

# send full update report
cat update_log.txt | python3 send_mail.py
cat update_log.txt
