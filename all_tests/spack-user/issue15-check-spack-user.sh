#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR SPACK-USER:"

# load and run basic spark file
echo "1. Load spack-user:"
module load spack-user
source $SPACK_USER_ROOT/share/spack/setup-env.sh
R1=$?
module list
echo "2. Install zlib with spack-user"
spack install zlib
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