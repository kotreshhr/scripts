#!/bin/bash                                                                     
while read line                                                                 
do                                                                              
    name=$line                                                                  
    #echo $name                                                                 
    len=${#line};                                                               
    #echo $len                                                                  
    if [ "$len" -ne 60 ]; then                                                  
        echo "LOOK OUT!!Not 60!!"                                               
        echo $name                                                              
        echo $len                                                               
    fi                                                                          
done < $1
