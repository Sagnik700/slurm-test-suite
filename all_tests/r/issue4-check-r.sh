#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR R:"

# load and run basic R file
echo "1. Load R:"
module load r
R1=$?
module list
echo "2. Run a R program"
Rscript ./all_tests/r/basic-r-code.r
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