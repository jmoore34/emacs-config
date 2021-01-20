tool=rewriter
tools=~/llvm-project/clang-tools-extra
build=~/build2/bin
tests=~/FuzzingBugGenerator/detection_tests
t=$tools
b=$build
bin=$b/$tool
PATH=/home/Jon/.local/bin:/home/Jon/.python/install/bin:/home/Jon/bin:$PATH
# function b() {
    # pushd $b/..
    # ninja $tool
    # popd
# }
function bl() {
    b|less
}
# function r() {
    # $b/$tool "$@"
# }
function br() {
    b && r "$@"
}
function cwe() {
    #docker run --rm -v /home/Jon:/mnt/Jon fkiecad/cwe_checker:stable bap "$@" --pass=cwe-checker #--cwe-checker-config=/mnt/Jon/config.json
    docker run --rm -itv /home/Jon:/mnt/Jon fkiecad/cwe_checker:stable bash
}
function dbt() {
    docker run -itv /home/Jon:/mnt/Jon 6016d5d504b1 bash
}
function dtest() {
    docker run --rm -itv /home/Jon:/mnt/Jon $1 sh        
}
function dbap() {
    # dtest binaryanalysisplatform/bap
    docker run --rm -v `pwd`:`pwd` binaryanalysisplatform/bap:latest bap "$@"
}
export -f dbap
function drm() {
    docker image rm $1
}
function bapd() {
    bap /bin/echo --primus-lisp-documentation | grep -C2 $*
}
export VISUAL="~/.local/share/emacs-26.3/src/emacs"
export EDITOR="$VISUAL"



function e() {
    ~/.local/share/emacs-26.3/src/emacs "$@"
}
## Colorize the ls output ##
alias ls='ls --color=auto'

## Use a long listing format ##
alias ll='ls -lah'

## Show hidden files ##
alias l.='ls -d .* --color=auto'

alias py=~/.python/install/bin/python3.8
py=~/.python/install/bin/python3.8
# alias pip="py -m pip"


alias b='cd ..'
alias bb='cd ../..'
alias bbb='cd ../../..'
alias bbbb='cd ../../../..'
alias bbbbb='cd ../../../../..'

function c() {
    cd `ls -d */ | grep -i $1 || echo '.'`
}

source ~/.bash_profile

function n() {
    nix-user-chroot ~/.nix bash
}
function t() {
    ~/FuzzingBugGenerator/tests/bap_tests/test.sh `ls *.o` &
}
function ct() {
    cd ~/t/`ls ~/t | grep $1`
}
function test() {
    ~/FuzzingBugGenerator/tests/bap_tests/test.sh "$@" &
}
function cm() {
    make clean && make
}
function setup() {
    ~/FuzzingBugGenerator/tests/bap_tests/test.sh
    cm
}
function s() {
    setup
}
function st() {
    setup
    t
}
function cmt() {
    cm
    t
}
# export bap="docker run --rm -v $HOME:$HOME binaryanalysisplatform/bap:latest bap"
export bap=bap

function mc () { mkdir -p "$@" && eval cd "\"\$$#\""; }
function c-all() {
    shopt -s globstar dotglob # allow recursing through directories
    for f in **/*.o; do
	echo Removing $f
	rm $f
    done
}
function m-all() {
    shopt -s extglob  # allow recursing through directories
    for f in **; do
	[[ -f $f/Makefile ]] && make -C "$f"
    done
}
function t-all() {
    shopt -s globstar dotglob # allow recursing through directories
    for f in **/*.o; do
	pushd `dirname $f` > /dev/null
	echo "Testing $f (pwd: `pwd`)"
	test `basename $f`
	popd > /dev/null
    done
}
function cmt-all() {
    c-all
    m-all
    t-all
}
function mm() { # mm(file, folder)
    mkdir $2
    mv $1 $2
}
function lg() {
    ls | grep $1
}
function r() {
    *.o
}
function sr() {
    s
    r
}
function cmr() {
    cm
    r
}
alias m=make
function fn() {
    export entry_points="$1"
    nm $bin | egrep " $1\$"
}
function tb() {
    test $bin
}
function heads() {
    for f in "$@"; do echo '*' ">>>>>>>>> $f <<<<<<<<<<"; head -n100 $f | cat -n; echo ""; done
}
function lsd() {
    ls -d */ "$@"
}
shopt -s globstar dotglob

# Python virtual environments
function venv() {
    py -m venv ~/.virtualenvs/$1
}
function venvs() {
    pushd ~/.virtualenvs/ > /dev/null
    lsd | grep -o '[^/]*'
    popd > /dev/null
}
function activate() {
    source ~/.virtualenvs/$1/bin/activate
}
function mcs() {
    cp obs obs-with-call-stack
    py ~/bt/call-stack.py obs-with-call-stack
}
function scs() {
    grep -E "null-pointer.+$1" obs-with-call-stack | egrep -o 'L=/.+' | sort -u
}
function scs2() {
    fgrep "null-pointer" obs-with-call-stack | egrep -o '\[([^]]?*)\]$' | sort -u
}
function def() {
    fgrep -rn --include '*.c' "$1" . | grep ')\w.$'
}
