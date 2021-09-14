#!/bin/bash

function main ()
{
    echo "start:`date +%T`"
    time $TIO_BIN -d $THIS_TEST_DIR -W -S -c 2>>$LOG_FILE 1>>$LOG_FILE

    if [ $? -ne 0 ]; then
        echo "end:`date +%T`"
        return 11;
    else
        echo "end:`date +%T`"
        return 0;
    fi
}

main "$@";