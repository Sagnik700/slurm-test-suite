#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR SINGULARITY:"

# load the singularity module
echo "1. Load singularity:"
module load singularity
#module load openmpi
R1=$?
module list
echo "2. Run a basic command to pull a .sif image with singularity"
singularity pull --name ./all_tests/singularity/sjupyter.sif shub://A33a/sjupyter
R2=$?
echo "3. Delete the downloaded image"
rm -rf ./all_tests/singularity/sjupyter.sif
R3=$?
echo "4. Test for checking lolcow/hello-world singularity container"
singularity pull --name ./all_tests/singularity/lolcowcontainer.sif docker://godlovedc/lolcow
singularity run ./all_tests/singularity/lolcowcontainer.sif
R4=$?
echo "5. Delete the downloaded lolcow image"
rm -rf ./all_tests/singularity/lolcowcontainer.sif
# sudo singularity build --sandbox ./all_tests/singularity/lolcow ./all_tests/singularity/lolcow/lolcow.def
# sudo singularity shell --writable ./all_tests/singularity/lolcow
# exit
R5=$?


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

printf "hostname:%s\nmodule_check_status:%s\n" $HOSTNAME $FINAL_RETURN_CODE > ./module_output.txt
