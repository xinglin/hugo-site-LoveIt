#!/bin/bash


# build the project
hugo

cd public
git add .

# Commit changes
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
  msg="$*"
fi

echo $msg

git commit -m "$msg"

echo "Publish" 
git push origin master
