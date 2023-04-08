#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR VALGRIND:"

# load the valgrind module
echo "1. Load valgrind:"
module load valgrind
module load gcc
R1=$?
module list
echo "2. Run a basic C programming file with memory leak issues to test Valgrind's output"
gcc ./all_tests/valgrind/basic-c-code-for-valgrind.c -o ./all_tests/valgrind/basic-c-code-for-valgrind.exe
valgrind --leak-check=full --log-file="./all_tests/valgrind/valgrind_output.out" -v ./all_tests/valgrind/basic-c-code-for-valgrind.exe
R2=$?
echo "3. Checking whether the valgrind output file is empty or not"
if [ -s ./all_tests/valgrind/valgrind_output.out ]; then
        R3=0
else
        R3=1
fi

FINAL_RETURN_CODE=0

if [ $R1 -ne 0 ]
then
FINAL_RETURN_CODE=1
fi
if [ $R2 -ne 0 ]
then
let "FINAL_RETURN_CODE = $(( $FINAL_RETURN_CODE + 10 ))"
fi
if [ $R3 -ne 0 ]
then
let "FINAL_RETURN_CODE = $(( $FINAL_RETURN_CODE + 100 ))"
fi

printf "hostname:%s\nmodule_check_status:%s\n" $HOSTNAME $FINAL_RETURN_CODE > ./module_output.txt
