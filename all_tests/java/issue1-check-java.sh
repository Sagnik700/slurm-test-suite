#!/bin/bash
#SBATCH -p int
#SBATCH -o ./logs/%j.out

echo ":BASIC TEST FOR LOADED MODULE CHECK FOR JAVA:"
HOSTNAME = $(hostname --fqdn)

# check java version
echo "1. Java version:"
java -version
R1=$?

# run basic java class
echo "2. Basic java class:"
javac ./all_tests/java/MyClass.java
java -classpath ./all_tests/java MyClass
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