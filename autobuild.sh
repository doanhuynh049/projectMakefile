#!/bin/bash

if [ -z "$1" ]; then 
    git branch -a
else 
    git show-branch "$s1"
    git checkout "$1"
    echo -n "Do you want to continue building build.sh? (y/n): "
    read confirm 
    while true; do
        case $confirm in
            [Yy]* ) ./build.sh; break;;
            [Nn]* ) exit;;
            * ) echo "Please enter y or n"; read confirm; sleep 1;;
        esac
    done
fi
