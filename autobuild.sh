#!/bin/bash
# git rev-parse HEAD
function build(){
    echo "List all revisions in branch "
    git log --oneline $1
    echo -n "which revision do you want to build (enter commit hash): "
    read revision
    
    if ! git branch --contains "$revision" &>/dev/null; then
        revision= git rev-parse HEAD
    fi
    # flag=false
    # while true; do
        
    #     if ! git branch --contains "$revision" &>/dev/null; then
    #         if ! $flag; then 
    #             echo -n "re-Enter the revision: "
    #             read revision
    #             flag=true
    #         fi
    #     else 
    #         break
    #     fi
        
    # done
    echo "Git revision: $revision"
    git checkout $revision
    ./build.sh
    git switch -
}
if [ -z "$1" ]; then 
    git branch -a
else 
    git show-branch "$s1"
    git checkout "$1"
    git pull        # to pull latest version of branch
    @echo "show branch used"
    git branch      # to show branch used
    @echo "branch status"
    git status
    echo -n "Do you need to clean existing thing or commit it? (enter to commit)"
    read clean
    if [ -z "$clean" ]; then
        git add .
        git commit -m "update"
        git push 
    else
        git clean -fdx
    fi
    echo -n "Do you want to continue building build.sh? (y/n): "
    read confirm 
     

    while true; do
        case $confirm in
            [Yy]* ) build $revision; break;;
            [Nn]* ) exit;;
            * ) @echo "Please enter y or n"; read confirm; sleep 1;;
        esac
    done
fi
