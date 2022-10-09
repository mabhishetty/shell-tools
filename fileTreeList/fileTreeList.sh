#!/bin/bash

# variable setup

RED='\033[0;31m'
CYAN='\033[0;36m'
BROWN='\033[0;33m'
NC='\033[0m' # No Color

fileDashes="${RED}---${NC}"
dirDashes="${CYAN}---${NC}"
dirPrefix="   ${CYAN}|${NC}"
maxDepth=$OPTARG
depth=-1

# function setup

printFile()
{
  echo -e "$fileDashes \b${RED}$item${NC}"
}

printDirectory()
{
  echo -e "$dirDashes${CYAN}$item${NC}"
  echo -e "$dirPrefix"
  prepend="   ${CYAN}|${NC}"
  pushd $item > /dev/null
  listStructure
  popd > /dev/null
}

printAnythingElse()
{
  echo -e "${dirPrefix}\b\b\b\b${BROWN}(empty)${NC}"
}


listStructure()
{
  local depth=$(($depth+1))

  if [ $depth -gt $maxDepth ]
  then
    echo -e "${dirPrefix}${BROWN}(cont.)${NC}"
    return
  fi 

  local prepend=$prepend
  local fileDashes="${prepend}${fileDashes}"
  local dirDashes="${prepend}${dirDashes}"
  local dirPrefix="${prepend}${dirPrefix}"
  local items=(*)

  for item in "${items[@]}"
  do
    if [ -f "$item" ]
    then
      printFile
    elif [ -d "$item" ]
    then
      printDirectory
    else
      printAnythingElse
    fi
  done
}

# main

while getopts ":hd:" opt;
do
  case ${opt} in
    h )
      echo "Tool to recursively show directory structure"
      echo "Usage:"
      echo "  ./fileTreeList.sh -d <int>"
      echo "    List files and directories, with a max depth of -d"
      echo "    Just listing the current directory's contents is a depth of 0"
      echo "  ./fileTreeList.sh -h"
      echo "    Get help"
      ;;
    d )
      maxDepth=$OPTARG
      listStructure
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
  esac
done
