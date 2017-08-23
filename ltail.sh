#!/bin/bash
#########################################################################
# ltail.sh (log tail)
#
# 담당 프로세스들의 로그 파일이 여기저기 흩어져있어서
# 일반 tail 명령으로 일일이 수행하기 불편해서 만듬
# 사용의 편의를 높이다 보니 -h 옵션을 우선은 없애버림
# 지금은 알아서 코드상에 있는 help를 보고 나중에 필요하면 옵션으로 빼도록
#########################################################################


function show_help() {
    printf "\n\n"
    echo "Usage: " 1>& 2
    echo "      [Last File]     $0 DMON " 1>& 2
    echo "      [SIP TU Number] $0 DMON 1 " 1>& 2
    echo "      [Any dir/file]  $0 DMON MAIN " 1>& 2
    printf "\n"
}

function sip_tu_tail() {
    if [[ $2 -eq 0 ]] ; then
        path="$HOME/log/$1_SIP/TU_0"
        file_name=`find $path -maxdepth 1 -type f | sort -n | tail -n 1`
        abs_path=$file_name
        echo $abs_path
        tail -f $abs_path | perl -pe 'while(<STDIN>) { my $line = $_; chomp($line); for($line){ s/.*call-id.*/\e[1;44m$&\e[0m/gi; s/.*Fail.*|at .*/\e[0;31m$&\e[0m/gi; s/.*CRITICAL.*|at .*/\e[0;31m$&\e[0m/gi; s/.*err.*|at .*/\e[0;31m$&\e[0m/gi; s/SVC.*/\e[1;32m$&\e[0m/gi; s/.*DBG.*/\e[1;33m$&\e[0m/gi; } print $line, "\n";}'

    else
        path="$HOME/log/$1_SIP/TU_$2"
        file_name=`find $path -maxdepth 1 -type f | sort -n | tail -n 1`
        abs_path=$file_name
        echo $abs_path
        tail -f $abs_path | perl -pe 'while(<STDIN>) { my $line = $_; chomp($line); for($line){ s/.*call-id.*/\e[1;44m$&\e[0m/gi; s/.*Fail.*|at .*/\e[0;31m$&\e[0m/gi; s/.*CRITICAL.*|at .*/\e[0;31m$&\e[0m/gi; s/.*err.*|at .*/\e[0;31m$&\e[0m/gi; s/SVC.*/\e[1;32m$&\e[0m/gi; s/.*DBG.*/\e[1;33m$&\e[0m/gi; } print $line, "\n";}'
    fi
}


function tail_dir() {
    if [[ -z $2 ]] ; then
        path="$HOME/log/$1"
    else
        dir=${2^^}
        path="$HOME/log/$1/$dir"
    fi
    find_cnt=`find $path -maxdepth 1 -type f | sort -n | tail -n 1 | wc -l`
    if [[ $find_cnt -eq 0 ]] ; then  # ~/log/DMON/SUBS/xxxx
        prefix=${2^^}
        path="$HOME/log/$1/$prefix*"
        find_cnt=`find $path -maxdepth 1 -type f | sort -n | tail -n 1 | wc -l`
        if [[ $find_cnt -eq 0 ]] ; then  # ~/log/DMON/IPC.xxxx
            path="$HOME/log/$1/$2*"
            find_cnt=`find $path -maxdepth 1 -type f | sort -n | tail -n 1 | wc -l`
            if [[ $find_cnt -eq 0 ]] ; then  # ~/log/DMON/tmon.xxxx
                echo "$path has no log file, maybe there are only directories."
                exit 1
            fi
        fi
    fi
    file_name=`find $path -maxdepth 1 -type f | sort -n | tail -n 1`

    echo $file_name
    abs_path=$file_name
    tail -f $abs_path | perl -pe 'while(<STDIN>) { my $line = $_; chomp($line); for($line){ s/.*call-id.*/\e[1;44m$&\e[0m/gi; s/.*Fail.*|at .*/\e[0;31m$&\e[0m/gi; s/.*CRITICAL.*|at .*/\e[0;31m$&\e[0m/gi; s/.*err.*|at .*/\e[0;31m$&\e[0m/gi; s/SVC.*/\e[1;32m$&\e[0m/gi; s/.*DBG.*/\e[1;33m$&\e[0m/gi; } print $line, "\n";}'
}

function tail_last_file() {
    path=`pwd`
    file_name=`find $path -maxdepth 1 -type f | sort -n | tail -n 1`
    abs_path=$file_name
    echo $abs_path
    tail -f $abs_path | perl -pe 'while(<STDIN>) { my $line = $_; chomp($line); for($line){ s/.*call-id.*/\e[1;44m$&\e[0m/gi; s/.*Fail.*|at .*/\e[0;31m$&\e[0m/gi; s/.*CRITICAL.*|at .*/\e[0;31m$&\e[0m/gi; s/.*err.*|at .*/\e[0;31m$&\e[0m/gi; s/SVC.*/\e[1;32m$&\e[0m/gi; s/.*DBG.*/\e[1;33m$&\e[0m/gi; } print $line, "\n";}'
}

## Main
if [[ $# -eq 0 ]] ; then
    tail_last_file
    exit 1
fi

process=${1^^}  # To upper case
re_num='^[0-9]+$'

if [[ ( $2 =~ $re_num ) ]]
then # TU number
    sip_tu_tail $process $2
else # directory
    tail_dir $process $2
fi

exit 0
