#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR GIT:"

# load git module
echo "1. Load git:"
module load git
R1=$?
module list
echo "2. Create a git repository"
git init ./all_tests/git/test_repo
R2=$?
cd ./all_tests/git/test_repo
git checkout -b new-branch
R3=$?
touch readme.txt
git add .
R4=$?
git commit -m "added"
R5=$?
rm -rf .git
R6=$?


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
if [ $R4 -ne 0 ]
then
let "FINAL_RETURN_CODE = $(( $FINAL_RETURN_CODE + 1000 ))"
fi
if [ $R5 -ne 0 ]
then
let "FINAL_RETURN_CODE = $(( $FINAL_RETURN_CODE + 10000 ))"
fi
if [ $R6 -ne 0 ]
then
let "FINAL_RETURN_CODE = $(( $FINAL_RETURN_CODE + 100000 ))"
fi

printf "hostname:%s\nmodule_check_status:%s\n" $HOSTNAME $FINAL_RETURN_CODE > ../../../module_output.txt