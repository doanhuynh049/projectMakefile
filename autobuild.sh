#!/bin/bash

# Usage:
#   ./autobuild.sh [branch_name]
#
#   If no branch name is provided, the script will show a list of all branches.
#   If a branch name is provided, the script will switch to that branch, update it to the latest version,
#   show the branch status, and prompt the user to build the project.

function build(){
    # List all revisions in the specified branch
    echo "List all revisions in branch "
    git log --oneline $1
    # Prompt the user to select a revision to build
    echo -n "which revision do you want to build (enter commit hash): "
    read revision
    # If the specified revision is not in the current branch, use the current HEAD
    if ! git branch --contains "$revision" &>/dev/null; then
        revision= git rev-parse HEAD
    fi
    echo "Git revision: $revision"
    # Checkout the specified revision
    git checkout $revision
    # Clean the project
    echo -n "Cleaning project..."
    make clean
    # Build the project
    echo -n "Building project..."
    make all
    # Create the image
    echo $PATH
    echo -n "Creating image..."
    ./mkappfsimg.sh
}

if [ -z "$1" ]; then 
    # If no branch name is provided, show a list of all branches
    git branch -a
else 
    # Switch to the specified branch, update to the latest version, and show status
    git show-branch "$s1"
    git checkout "$1"
    git pull        # to pull latest version of branch
    echo "show branch used"
    git branch      # to show branch used
    echo "branch status"
    git status
    # Check for changes in the working tree
    if ! git diff-index --quiet HEAD --; then
        echo -n "Do you need to commit or clean changes? (y/Y to commit): "
        read clean
        case $clean in
            [Yy]* ) git add .;
                    git commit -m "update";
                    git push --set-upstream origin $1; break;;
            [Nn]* ) git clean -fdx;;
            * ) echo -n "Please enter y or n: "; read clean; sleep 1;;
        esac
    fi
    
    source ~/.bashrc
    echo -n "Do you want to continue building mkappfsimg.sh? (y/n): "
    read confirm 
     
    while true; do
        case $confirm in
            [Yy]* ) build $revision; break;;
            [Nn]* ) echo "Aborting..."; break;;
            * ) echo "Please enter y or n"; read confirm; sleep 1;;
        esac
    done

    # Check the image size and prompt the user to continue or abort
    echo -n "Image size:"
    ls -lh appfs.rel.sqfs.img 
    size=$(du -k appfs.rel.sqfs.img | awk '{print $1}')
    if [[ $size -gt 8000 || $size -lt 7000 ]]; then
        echo -n "The image size is $size KB. Do you want to continue? (y/n): "
        read confirm_size
        case ${confirm_size:0:1} in
            Nn]* ) echo "Exiting...";
                    exit 1;;
        esac
    else 
        echo "The image size is $size KB. It is OKIE!"
    fi

    # Copy the image to the specified location, and prompt the user to flash the display
    echo -n "Do you want to copy image to storing (root@192.168.2.100:/tmp/dis)? (y/n): "
    read image
    if [ "$image"  == "y" ]; then
        echo "Copying..."
        scp -r -O appfs.rel.sqfs.img root@192.168.2.100:/tmp/dis
        echo -n "Do you want to flash diplay? (y/n): "
        read flash
        if [ "$flash" == "y" ]; then
            ssh root@192.168.2.100:/tmp/dis
            # update_dis.sh appfs B
            # devmem 0xc8000024 16 1
        fi
    fi
    git switch -
fi