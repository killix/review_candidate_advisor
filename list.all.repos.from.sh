#!/bin/bash
# Update all git directories below current directory or specified directory
# Skips directories that contain a file called .ignore

STARTING_DIR=`pwd 2>&1`
GIT_REPO_LIST_FILE="${STARTING_DIR}/git-repo-list"
let COUNT=0

function update {
  local d="$1"
  if [ -d "$d" ]; then
    if [ -e "$d/.ignore" ]; then 
      echo -e "${HIGHLIGHT}Ignored! $d${NORMAL}"
    else
      cd $d > /dev/null
      if [ -d ".git" ]; then
        echo -e "${HIGHLIGHT}>> `pwd`$NORMAL"
        `git pull 2>/dev/null`
        pwd >> "$GIT_REPO_LIST_FILE"
        ((COUNT++))
      else
        scan *
      fi
      cd .. > /dev/null
    fi
  fi
  #echo "Exiting update: pwd=`pwd`"
}

function scan {
  #echo "`pwd`"
  for x in $*; do
    update "$x"
  done
}

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'

[[ -f "$GIT_REPO_LIST_FILE" ]] && rm -f "$GIT_REPO_LIST_FILE"
if [ "$1" != "" ]; then cd $1 > /dev/null; fi
echo -e "${HIGHLIGHT}Scanning ${PWD}${NORMAL}"
scan * 
echo -e "${HIGHLIGHT}Scanning completed (total : ${COUNT} repos)${NORMAL}"
