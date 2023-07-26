#!/bin/bash
function build(){
    echo "List all revision in builded branch "
    git log --oneline $1
    echo -n "which revision you want to build: "
    read revision
    # if [ -z "$revision"]; then 
    #     revision = $(git log -n 1 --pretty=format:%H)
    # fi
    echo "Git revision: $revision"


    echo $revision
    ./build.sh
}
if [ -z "$1" ]; then 
    git branch -a
else 
    git show-branch "$s1"
    git checkout "$1"
    echo -n "Do you want to continue building build.sh? (y/n): "
    read confirm 
    



    while true; do
        case $confirm in
            [Yy]* ) build; break;;
            [Nn]* ) exit;;
            * ) echo "Please enter y or n"; read confirm; sleep 1;;
        esac
    done
fi
