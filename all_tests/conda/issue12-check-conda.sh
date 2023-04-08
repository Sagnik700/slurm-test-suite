#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR CONDA:"
FINAL_RETURN_CODE=0

# load anaconda3
echo "1. Load anaconda3:"
module load anaconda3
conda --version


####### Python 3.7 ######
echo "2. Create a new environment named 'tf-conda-07' with Python 3.7"
conda create --prefix /tmp/slurm_test_suite/tf-conda-07 python=3.7 pip
# activate the freshly created environment
source activate /tmp/slurm_test_suite/tf-conda-07
# install packages
pip install --user torch tensorflow numpy keras
# run the module tests
python ./all_tests/conda/py_07_success_check.py
P070=$?
python ./all_tests/conda/py_07_failure_check.py
P071=$?
python ./all_tests/conda/pytorch_test.py
P072=$?
python ./all_tests/conda/tensorflow_test.py
P073=$?
# exit the environment
conda deactivate
rm -rf /tmp/slurm_test_suite/tf-conda-07
if [ $P070 -eq 0 ] && [ $P071 -ne 0 ] && [ $P072 -eq 0 ] && [ $P073 -eq 0 ]
then
    echo "Python 3.7 tests passed"
else
    FINAL_RETURN_CODE=1
fi

  

####### Python 3.8 ######
echo "2. Create a new environment named 'tf-conda-08' with Python 3.8"
conda create --prefix /tmp/slurm_test_suite/tf-conda-08 python=3.8 pip
# activate the freshly created environment
source activate /tmp/slurm_test_suite/tf-conda-08
# install packages
pip install --user torch tensorflow numpy keras
# run the module tests
python ./all_tests/conda/py_08_success_check.py
P080=$?
python ./all_tests/conda/py_08_failure_check.py
P081=$?
python ./all_tests/conda/pytorch_test.py
P082=$?
python ./all_tests/conda/tensorflow_test.py
P083=$?
# exit the environment
conda deactivate
rm -rf /tmp/slurm_test_suite/tf-conda-08
if [ $P080 -eq 0 ] && [ $P081 -ne 0 ] && [ $P082 -eq 0 ] && [ $P083 -eq 0 ]
then
    echo "Python 3.8 tests passed"
else
    let "FINAL_RETURN_CODE = $(( $FINAL_RETURN_CODE + 10 ))"
fi


####### Python 3.9 ######
echo "2. Create a new environment named 'tf-conda-09' with Python 3.9"
conda create --prefix /tmp/slurm_test_suite/tf-conda-09 python=3.9 pip
# activate the freshly created environment
source activate /tmp/slurm_test_suite/tf-conda-09
# install packages
pip install --user torch tensorflow numpy keras
# run the module tests
python ./all_tests/conda/py_09_success_check.py
P090=$?
python ./all_tests/conda/py_09_failure_check.py
P091=$?
python ./all_tests/conda/pytorch_test.py
P092=$?
python ./all_tests/conda/tensorflow_test.py
P093=$?
# exit the environment
conda deactivate
rm -rf /tmp/slurm_test_suite/tf-conda-09
if [ $P090 -eq 0 ] && [ $P091 -ne 0 ] && [ $P092 -eq 0 ] && [ $P093 -eq 0 ]
then
    echo "Python 3.9 tests passed"
else
    let "FINAL_RETURN_CODE = $(( $FINAL_RETURN_CODE + 100 ))"
fi



####### Python 3.10 ######
echo "2. Create a new environment named 'tf-conda-10' with Python 3.10"
conda create --prefix /tmp/slurm_test_suite/tf-conda-10 python=3.10 pip
# activate the freshly created environment
source activate /tmp/slurm_test_suite/tf-conda-10
# install packages
pip install --user torch tensorflow numpy keras
# run the module tests
python ./all_tests/conda/py_10_success_check.py
P100=$?
python ./all_tests/conda/py_10_failure_check.py
P101=$?
python ./all_tests/conda/pytorch_test.py
P102=$?
python ./all_tests/conda/tensorflow_test.py
P103=$?
# exit the environment
conda deactivate
rm -rf /tmp/slurm_test_suite/tf-conda-10
if [ $P100 -eq 0 ] && [ $P101 -ne 0 ] && [ $P102 -eq 0 ] && [ $P103 -eq 0 ]
then
    echo "Python 3.10 tests passed"
else
    let "FINAL_RETURN_CODE = $(( $FINAL_RETURN_CODE + 1000 ))"
fi

printf "hostname:%s\nmodule_check_status:%s\n" $HOSTNAME $FINAL_RETURN_CODE > ./module_output.txt