#!/bin/bash

function main ()
{
    SCRIPTS_DIR=$(dirname $0);

    echo "start: $(date +%T)";
    #time $SCRIPTS_PATH/rpc-coverage.sh $THIS_TEST_DIR 2>>$LOG_FILE 1>>$LOG_FILE;
    time $SCRIPTS_DIR/rpc-coverage.sh $THIS_TEST_DIR 2>>$LOG_FILE 1>>$LOG_FILE;
    if [ $? -ne  0 ]; then
	echo "end: $(date +%T)";
	return 22;
    else
	echo "end: $(date +%T)";
	return 0;
    fi
}

main "$@"