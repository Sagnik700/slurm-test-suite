#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR GCC:"

# load and run basic C file
echo "1. Load openmpi and gcc:"
module load gcc
module load openmpi
R1=$?
module list
echo "2. Run a basic OpenMPI program"
mpicc ./all_tests/openmpi/basic-openmpi-code.c -o ./all_tests/openmpi/basic-openmpi-code
mpirun ./all_tests/openmpi/basic-openmpi-code
R2=$?
echo "3. Run a OpenMPI program with multi-process-communication"
mpicc ./all_tests/openmpi/multi-process-communication.c -o ./all_tests/openmpi/multi-process-communication
mpirun ./all_tests/openmpi/multi-process-communication
R3=$?
echo "4. Run a OpenMPI program with singularity"
module load singularity
mpicc ./all_tests/openmpi/openmpi_singularity.c -o ./all_tests/openmpi/openmpi_singularity
mpirun ./all_tests/openmpi/openmpi_singularity
R4=$?

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

printf "hostname:%s\nmodule_check_status:%s\n" $HOSTNAME $FINAL_RETURN_CODE > ./module_output.txt
