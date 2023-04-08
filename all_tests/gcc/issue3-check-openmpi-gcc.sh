#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR OPENMPI/GCC:"

# load and run basic C file
echo "1. Load gcc openmpi:"
module unload gcc
module unload openmpi
module load gcc openmpi
R1=$?
module list
echo "2. Run a C program"
gcc ./all_tests/gcc/basic-c-code.c -o ./all_tests/gcc/basic-c-code.exe
./all_tests/gcc/basic-c-code.exe
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