#!/bin/bash

msg="add content $(date)"
if [ -n "$*" ]; then
  msg="$*"
fi

git add .
git commit -m "$msg"
git push origin master
