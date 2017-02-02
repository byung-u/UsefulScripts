#!/bin/csh -f

# 회사에서 csh, tcsh 사용. 
# grep 결과를 복사 붙여넣기해서 파일을 열어보는데 일부 문자열 바꾸기 귀찮아서 만들게 
# 기존 grep 수행 결과  -> xxx.c:73  blah blah blah
# 이 스크립트 수행 하면 -> vir xxx.c +73  blah blah blah
# 매번 vir을 치고 :를 지우고 스페이스바 + '+' 바꿔주는 작업이 귀찮아서 만듬.

# 세팅 
# alias vir 'vim -R'

if ($#argv < 2) then
    echo "Argument count: $#argv"
    echo "USAGE : $0 pattern file"
    exit 1
endif

@ i = 2
while ($i < $#argv)
    grep -nH --color=auto $1 $argv[$i] | sed 's/c:/c +/g' | sed 's/^/vir /g'
    @ i++
end
