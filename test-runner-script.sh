#!/bin/bash

echo ":THE HOSTNAME IS:"
hostname --fqdn
MODULE_CHECK_OUTPUT_FILENAME='module_output.txt'
echo "-------------------------------------------------"
echo "CHECK WHETHER LOGS FOLDER HAS SPACE"
NUM_LOG_FILES=$(ls -1q logs | wc -l)
if [ $NUM_LOG_FILES -ge 50 ]
then
NUM_TAR_FILES=$(ls -1q logs_archive | wc -l)
tar czf ./logs_archive/slurm_output_$(( $NUM_TAR_FILES + 1 )).tar.gz ./logs/*
rm ./logs/*
echo "  -LOGS FOLDER EMPTIED. TAR FILE SAVED IN LOGS_ARCHIVE."
else
echo "  -LOGS FOLDER HAS SPACE."
fi
echo "-------------------------------------------------"
echo ":BASIC TEST FOR LOADED MODULES:"

SBATCH_ARGUMENTS=""
MODULES_CONFIG=""
declare -a MODULES_INLINE=()

if [ $# -eq 0 ] || [[ "$@" == *"--default"* ]]
then
    echo "*Config file will be used to check Slurm commands and modules to run.*"
    MODULES_INLINE="None"
    while read -r line; do
        if [[ "$(awk '{print $1}' <<<"$line")" == 'export' ]]; then
            VAR_NAME="$(awk '{print $2}' <<<"$line" | awk -F'=' '{print $1}')"
            VAR_VALUE="$(awk -F\" '{print $2}' <<<"$line")"
            if [[ "$@" == *"--default"* ]] && [[ $VAR_NAME == *"def_sbatch"* ]] && [[ ! -z "$VAR_VALUE" ]]
            then
                MODULES_CONFIG="ALL"
                IFS='_' read -r -a array <<< $VAR_NAME
                #echo "${array[2]}"
                SBATCH_ARGUMENTS="${SBATCH_ARGUMENTS} --${array[2]} $VAR_VALUE"
            elif [[ $VAR_NAME == *"sbatch"* ]] && [[ ! -z "$VAR_VALUE" ]]
            then
                IFS='_' read -r -a array <<< $VAR_NAME
                #echo "${array[1]}"
                SBATCH_ARGUMENTS="${SBATCH_ARGUMENTS} --${array[1]} $VAR_VALUE"
            elif [[ $VAR_NAME == "modules_all" ]] && [[ $VAR_VALUE == "1" ]]
            then
                MODULES_CONFIG="ALL"
                break
            elif [[ $VAR_NAME == *"modules"* ]] && [[ $VAR_VALUE == "1" ]]
            then
                IFS='_' read -r -a array <<< $VAR_NAME
                #echo "${array[1]}"
                MODULES_CONFIG="${MODULES_CONFIG} ${array[1]}"
            fi
            #echo -e "${VAR_NAME}\n${VAR_VALUE}"
        else
            continue
        fi
    done<"./config.cfg"
else
    MODULES_INLINE=("$@")
fi

# Python
if [[ ${MODULES_INLINE[@]} == *"python"* ]] || [[ $MODULES_CONFIG == *"python"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/python/issue1-check-py.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/python/issue1-check-py.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "PYTHON module check passed."
            else
                echo "PYTHON modules that FAILED are as follows:-"
            fi    
            if [ $MODULE_STATUS -ge 1000 ]
            then
                echo "  ->Running basic python script after loading anaconda3 and creating a virtual environment"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 1000 ))"
            fi
            if [ $MODULE_STATUS -ge 100 ]
            then
                echo "  ->Running basic python script from the terminal with python command"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100 ))"
            fi
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running inline python script from the terminal with python command"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi    
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Checking python version"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi    

# Java
if [[ ${MODULES_INLINE[@]} == *"java"* ]] || [[ $MODULES_CONFIG == *"java"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/java/issue1-check-java.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/java/issue1-check-java.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "JAVA module check passed."
            else
                echo "JAVA modules that FAILED are as follows:-"
            fi    
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running basic java file MyClass.java"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Checking java version"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# Matlab
if [[ ${MODULES_INLINE[@]} == *"matlab"* ]] || [[ $MODULES_CONFIG == *"matlab"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/matlab/issue1-check-matlab.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/matlab/issue1-check-matlab.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "MATLAB module check passed."
            else
                echo "MATLAB modules that FAILED are as follows:-"
            fi    
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running basic matlab file basicMatlabScript.m"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading matlab module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# Gcc
if [[ ${MODULES_INLINE[@]} == *"gcc"* ]] || [[ $MODULES_CONFIG == *"gcc"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/gcc/issue3-check-gcc.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/gcc/issue3-check-gcc.sh
    fi    
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "GCC module check passed."
            else
                echo "GCC modules that FAILED are as follows:-"
            fi    
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running basic C program basic-c-code.c"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading gcc module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME

    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/gcc/issue3-check-openmpi-gcc.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/gcc/issue3-check-openmpi-gcc.sh
    fi  
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "OPENMPI/GCC module check passed."
            else
                echo "OPENMPI/GCC modules that FAILED are as follows:-"
            fi    
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running basic C program basic-c-code.c"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading openmpi/gcc module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# OpenMPI
if [[ ${MODULES_INLINE[@]} == *"openmpi"* ]] || [[ $MODULES_CONFIG == *"openmpi"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/openmpi/issue3-check-openmpi.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/openmpi/issue3-check-openmpi.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "OpenMPI module check passed."
            else
                echo "OpenMPI modules that FAILED are as follows:-"
            fi   
            if [ $MODULE_STATUS -ge 1000 ]
            then
                echo "  ->Running OpenMPI program with singularity"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 1000 ))"
            fi 
            if [ $MODULE_STATUS -ge 100 ]
            then
                echo "  ->Running OpenMPI program multi-process-communication.c"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100 ))"
            fi
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running basic OpenMPI program basic-openmpi-code.c"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading OpenMPI module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi    

# Go
if [[ ${MODULES_INLINE[@]} == "go" ]] || [[ $MODULES_CONFIG == *"go"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/go/issue4-check-go.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/go/issue4-check-go.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "GO module check passed."
            else
                echo "GO modules that FAILED are as follows:-"
            fi    
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running basic GO program basic-go-code.go"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading go module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi


# R
if [[ ${MODULES_INLINE[@]} == "r" ]] || [[ $MODULES_CONFIG == *"r"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/r/issue4-check-r.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/r/issue4-check-r.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "R module check passed"
            else
                echo "R modules that FAILED are as follows:-"
            fi    
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running basic R program basic-r-code.r"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading R module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi


# JQ
if [[ ${MODULES_INLINE[@]} == *"jq"* ]] || [[ $MODULES_CONFIG == *"jq"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/jq/issue4-check-jq.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/jq/issue4-check-jq.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "JQ module check passed."
            else
                echo "JQ modules that FAILED are as follows:-"
            fi   
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running basic JQ test with fruit.json"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading JQ module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi


# Octave
if [[ ${MODULES_INLINE[@]} == *"octave"* ]] || [[ $MODULES_CONFIG == *"octave"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/octave/issue4-check-octave.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/octave/issue4-check-octave.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Octave module check passed."
            else
                echo "Octave modules that FAILED are as follows:-"
            fi   
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running basicOctaveScript.m"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading Octave module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi


# Rclone
if [[ ${MODULES_INLINE[@]} == *"rclone"* ]] || [[ $MODULES_CONFIG == *"rclone"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/rclone/issue4-check-rclone.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/rclone/issue4-check-rclone.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Rclone module check passed."
            else
                echo "Rclone modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 100 ]
            then
                echo "  ->Making a folder with mkdir"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100 ))"
            fi   
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Removing a folder with rmdir"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading Rclone module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi


# Samtools
if [[ ${MODULES_INLINE[@]} == *"samtools"* ]] || [[ $MODULES_CONFIG == *"samtools"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/samtools/issue4-check-samtools.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/samtools/issue4-check-samtools.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Samtools module check passed."
            else
                echo "Samtools modules that FAILED are as follows:-"
            fi 
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Viewing a .sam file with samtools"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading Samtools module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# Singularity
if [[ ${MODULES_INLINE[@]} == *"singularity"* ]] || [[ $MODULES_CONFIG == *"singularity"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/singularity/issue4-check-singularity.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/singularity/issue4-check-singularity.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Default singularity module check passed."
            else
                echo "Default singularity modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 10000 ]
            then
                echo "  ->Deleting the lolcow image"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10000 ))"
            fi  
            if [ $MODULE_STATUS -ge 1000 ]
            then
                echo "  ->Pulling the lolcow image from docker and running it"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 1000 ))"
            fi  
            if [ $MODULE_STATUS -ge 100 ]
            then
                echo "  ->Deleting an image pulled with singularity"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100 ))"
            fi   
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Pulling an image with the singularity module"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading Singularity module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME

    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/singularity/issue4-check-singularity-3-7-0.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/singularity/issue4-check-singularity-3-7-0.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Singularity 3.7.0 module check passed."
            else
                echo "Singularity 3.7.0  modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 10000 ]
            then
                echo "  ->Deleting the lolcow image"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10000 ))"
            fi  
            if [ $MODULE_STATUS -ge 1000 ]
            then
                echo "  ->Pulling the lolcow image from docker and running it"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 1000 ))"
            fi  
            if [ $MODULE_STATUS -ge 100 ]
            then
                echo "  ->Deleting an image pulled with singularity"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100 ))"
            fi   
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Pulling an image with the singularity module"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading Singularity module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# Valgrind
if [[ ${MODULES_INLINE[@]} == *"valgrind"* ]] || [[ $MODULES_CONFIG == *"valgrind"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/valgrind/issue4-check-valgrind.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/valgrind/issue4-check-valgrind.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Valgrind module check passed."
            else
                echo "Valgrind modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 100 ]
            then
                echo "  ->Checking whether the valgrind output file is empty or not"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100 ))"
            fi   
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running a basic C programming file with memory leak issues to test Valgrind's output"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading Valgrind module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# Git
if [[ ${MODULES_INLINE[@]} == *"git"* ]] || [[ $MODULES_CONFIG == *"git"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/git/issue9-check-git.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/git/issue9-check-git.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Git module check passed."
            else
                echo "Git modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 100000 ]
            then
                echo "  ->Checking whether the git repository got deleted or not"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100000 ))"
            fi   
            if [ $MODULE_STATUS -ge 10000 ]
            then
                echo "  ->Git commit step failed"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10000 ))"
            fi
            if [ $MODULE_STATUS -ge 1000 ]
            then
                echo "  ->Git add step failed"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 1000 ))"
            fi
            if [ $MODULE_STATUS -ge 100 ]
            then
                echo "  ->Git checkout to new branch failed"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100 ))"
            fi
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Git init for creating a new repository failed"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading Git module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# Spark
if [[ ${MODULES_INLINE[@]} == *"spark"* ]] || [[ $MODULES_CONFIG == *"spark"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/spark/issue4-check-spark.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/spark/issue4-check-spark.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "SPARK module check passed."
            else
                echo "SPARK modules that FAILED are as follows:-"
            fi    
            if [ $MODULE_STATUS -ge 1000 ]
            then
                echo "  ->Shutting down the job cluster with scc_spark_shutdown.sh"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 1000 ))"
            fi
            if [ $MODULE_STATUS -ge 100 ]
            then
                echo "  ->Deploying spark-shell"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100 ))"
            fi
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running scc_spark_deploy.sh"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi    
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading the spark module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi    

# Gromacs
if [[ ${MODULES_INLINE[@]} == *"gromacs"* ]] || [[ $MODULES_CONFIG == *"gromacs"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/gromacs/issue13-check-gromacs.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/gromacs/issue13-check-gromacs.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Default gromacs module check passed."
            else
                echo "Default gromacs modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 100 ]
            then
                echo "  ->Removing .itp and .top files"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100 ))"
            fi 
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running the pdb2gmx command"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading Gromacs module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME

    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/gromacs/issue13-check-gromacs-2021-3.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/gromacs/issue13-check-gromacs-2021-3.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Gromacs/2021.3 module check passed."
            else
                echo "Gromacs/2021.3 modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 100 ]
            then
                echo "  ->Removing .itp and .top files"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100 ))"
            fi 
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Running the pdb2gmx command"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading Gromacs module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi


# Conda
if [[ ${MODULES_INLINE[@]} == *"conda"* ]] || [[ $MODULES_CONFIG == *"conda"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/conda/issue12-check-conda.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/conda/issue12-check-conda.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Conda module check for Python 3.7, 3.8, 3.9, 3.10 passed."
            else
                echo "Conda modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 1000 ]
            then
                echo "  ->Python 3.10 modules"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 1000 ))"
            fi 
            if [ $MODULE_STATUS -ge 100 ]
            then
                echo "  ->Python 3.9 modules"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 100 ))"
            fi 
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Python 3.8 modules"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Python 3.7 modules"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# Spack-User
if [[ ${MODULES_INLINE[@]} == *"spack-user"* ]] || [[ $MODULES_CONFIG == *"spack-user"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/spack-user/issue15-check-spack-user.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/spack-user/issue15-check-spack-user.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Spack-user module check passed."
            else
                echo "Spack-user modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Installing zlib with spack"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading spack-user module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# Mafft
if [[ ${MODULES_INLINE[@]} == *"mafft"* ]] || [[ $MODULES_CONFIG == *"mafft"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/mafft/issue16-check-mafft.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/mafft/issue16-check-mafft.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Mafft module check passed."
            else
                echo "Mafft modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Performing Sequence Alignment on 2019-nCoV data with MAFFT"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading mafft module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# Gatk
if [[ ${MODULES_INLINE[@]} == *"gatk"* ]] || [[ $MODULES_CONFIG == *"gatk"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/gatk/issue17-check-gatk.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/gatk/issue17-check-gatk.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Gatk module check passed."
            else
                echo "Gatk modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Performing a conversion relative to the Picard-style syntax on a .bam file"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading gatk module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# BWA
if [[ ${MODULES_INLINE[@]} == *"bwa"* ]] || [[ $MODULES_CONFIG == *"bwa"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/bwa/issue18-check-bwa.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/bwa/issue18-check-bwa.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Bwa module check passed."
            else
                echo "Bwa modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Making an index of the reference genome in fasta format"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading bwa module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi

# BOWTIE2
if [[ ${MODULES_INLINE[@]} == *"bowtie2"* ]] || [[ $MODULES_CONFIG == *"bowtie2"* ]] || [[ $MODULES_CONFIG == *"ALL"* ]]
then
    if [ -z "$SBATCH_ARGUMENTS" ]
    then
        sbatch --wait ./all_tests/bowtie2/issue19-check-bowtie2.sh
    else
        sbatch $SBATCH_ARGUMENTS --wait ./all_tests/bowtie2/issue19-check-bowtie2.sh
    fi
    while read line; do
        # reading each line
        if [[ $line == *"hostname"* ]]
        then
            COMPUTE_NODE=$( echo $line | cut -d ":" -f2 ) 
            echo "Slurm compute node hostname : $COMPUTE_NODE"
        else
            MODULE_STATUS=$( echo $line | cut -d':' -f 2 )
            if [ $MODULE_STATUS -eq 0 ]
            then
                echo "Bowtie2 module check passed."
            else
                echo "Bowtie2 modules that FAILED are as follows:-"
            fi
            if [ $MODULE_STATUS -ge 10 ]
            then
                echo "  ->Creating an index for the Lambda phage reference genome included with Bowtie 2"
                let "MODULE_STATUS = $(( $MODULE_STATUS - 10 ))"
            fi
            if [ $MODULE_STATUS -ge 1 ]
            then
                echo "  ->Loading bowtie2 module"
            fi
        fi
    done < $MODULE_CHECK_OUTPUT_FILENAME
fi