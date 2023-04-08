#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR GROMACS:"

# load GROMACS module
echo "1. Load default gromacs:"
module load gromacs
R1=$?
module list
echo "2. Run a GROMACS command"
gmx_mpi pdb2gmx -f ./all_tests/gromacs/1aki_clean.pdb -o ./all_tests/gromacs/output/1aki_processed.gro -water spce -ff gromos53a6
R2=$?
rm -rf posre.itp
rm -rf topol.top
R3=$?

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