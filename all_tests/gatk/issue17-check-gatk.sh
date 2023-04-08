#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR GATK:"

# load module
echo "1. Load gatk:"
module load gatk
R1=$?
module list
echo "2. Perform a conversion relative to the Picard-style syntax on a .bam file"
gatk ValidateSamFile -I ./all_tests/gatk/wgEncodeUwRepliSeqK562G1AlnRep1.bam -MODE SUMMARY
R2=$?

FINAL_RETURN_CODE=0

if [ $R1 -ne 0 ]
then
FINAL_RETURN_CODE=1
fi
if [ $R2 -ne 4 ]
# ValidateSamFile NM validation cannot be performed without the reference. All other validations will still occur.
# Return code 4 proves that picard.sam.ValidateSamFile is done. Run once and check the log file for better understanding.
then
let "FINAL_RETURN_CODE = $(( $FINAL_RETURN_CODE + 10 ))"
fi

printf "hostname:%s\nmodule_check_status:%s\n" $HOSTNAME $FINAL_RETURN_CODE > ./module_output.txt