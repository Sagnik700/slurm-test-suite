#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR BOWTIE2:"

# load module
echo "1. Load bowtie2:"
module load bowtie2
R1=$?
module list
echo "2. Create an index for the Lambda phage reference genome included with Bowtie 2"
bowtie2-build ./all_tests/bowtie2/NC_001416.1.fa lambda_virus
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