#!/bin/bash
function build(){
    git checkout $1
    ./build.sh
     git switch -
}
if [ -z "$1" ]; then 
    git branch -a
else 
    git show-branch "$s1"
    git checkout "$1"
    echo -n "Do you want to continue building build.sh? (y/n): "
    read confirm 
     echo "List all revisions in branch "
    git log --oneline $1
    echo -n "which revision do you want to build (enter commit hash): "
    read revision
    echo "Git revision: $revision"


    while true; do
        case $confirm in
            [Yy]* ) build $revision; break;;
            [Nn]* ) exit;;
            * ) echo "Please enter y or n"; read confirm; sleep 1;;
        esac
    done
fi
