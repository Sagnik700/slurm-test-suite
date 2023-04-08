#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR MAFFT:"

# load module
echo "1. Load mafft:"
module load mafft
R1=$?
module list
echo "2. Perform Sequence Alignment on 2019-nCoV data with MAFFT(check 3rd link in references.txt)"
mafft --auto --clustalout --reorder "./all_tests/mafft/SEQUENCES.txt" > "./all_tests/mafft/output.txt"
R2=$?

FINAL_RETURN_CODE=0

if [ $R1 -ne 0 ]
then
FINAL_RETURN_CODE=1
fi
if [ $R2 -ne 0 ]
then
let "FINAL_RETURN_CODE = $(( $FINAL_RETURN_CODE + 10 ))"
fi

printf "hostname:%s\nmodule_check_status:%s\n" $HOSTNAME $FINAL_RETURN_CODE > ./module_output.txt