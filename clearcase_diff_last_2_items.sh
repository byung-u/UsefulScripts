#!/bin/bash
# Clearcase diff with last checked in files.
CLT="/opt/ibm/RationalSDLC/clearcase/linux_x86/bin/cleartool"
PWD=`pwd`


function show_help() {
  echo "\n\nUsage: " 1>& 2
  echo "   $0 xxxx.c" 1>& 2
  echo "   $0 xxxx.c xxxx.c xxxx.h" 1>& 2
}


function error() {                                                              
  echo "[ERR]: $*" 1>&2                                                       
}     


function get_last_file() {
  curr_num=`echo $1 | rev | cut -d '/' -f 1 | rev`
  if [ "CHECKEDOUT" == $curr_num ]; then
    last_num=$2
  else
    last_num=$(($curr_num - 1 ))
  fi

  root_file=`echo $1 | rev | cut -d '/' -f2- | rev`
  last_file="$root_file/$last_num"
}


## Main
if [[ $# -lt 1 ]] ; then
  error "At least 1 argument required"
  show_help
  exit 1
fi

for file in "$@"
do
  # KDG_A.c@@/main/CHECKEDOUT from /main/1          Rule: CHECKEDOUT
  cur_file1=`$CLT ls | grep -n $file |grep -v '.swp' | awk '{print $1}' | cut -d ':' -f 2`
  # KDG_B.c@@/main/2                                Rule: /main/LATEST
  cur_file2=`$CLT ls | grep -n $file |grep -v '.swp' | awk '{print $3}' | cut -d '/' -f 3`

  # get last file name
  get_last_file $cur_file1 $cur_file2

  if [[ $last_num -eq 0 ]] ; then
    echo "$cur_file is not modified"
    continue
  fi
  echo $last_file $file
  vimdiff $last_file $file < /dev/tty
done

exit 0
