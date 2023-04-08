#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR PYTHON:"

# check python version
echo "1. Python version:"
python --version
R1=$?

# run basic python script
echo "2. Basic inline python command:"
python -c "import numpy as np; print('Sum of 3 & 4 is: ', np.add(3.0, 4.0))"
R2=$?

echo "3. Basic python script:"
python ./all_tests/python/basic-py-check.py
R3=$?


# load the anaconda module, create an env, use pip to install packages and run a python script
echo "4. Load Anaconda3:"
module load anaconda3
module list
# # create a new environment named 'test-suite-env-1' for a specific python version containing a recent version of pip
conda create -n test-suite-env-1 python=3.8 pip
# # activate the freshly created environment
source activate test-suite-env-1
# # install some packages using pip
# # '--user' is important, otherwise you may get permission errors
pip install --user numpy pandas
# # run basic python script
python ./all_tests/python/basic-py-check.py
R4=$?
# # exit the environment
conda deactivate

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