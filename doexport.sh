#!/bin/bash

DOWRITE="NO"
DOCHECK="NO"
PROGNAME=$(basename $0)

print_usage() {
    echo "Usage: $PROGNAME -c | -w"
    echo ""
    echo "-c     checks for env files being different, shouldn't work for dirs"
    echo "-w     copies files into appopriate place (homedir)"
    echo "       use -h to show this help"
}

print_help() {
    echo ""
    print_usage
    echo ""
    echo "This script intended to make export environment related files into current user's homedir" 
}

if [ -z $1 ];then
	print_help
	exit 1
fi
# parsing arguments

while getopts ":hcw" Option; do
  case $Option in
    h)
      print_help
      exit 0
      ;;
    c)
      DOCHECK="YES"
      ;;
    w)
      DOWRITE="YES"
      ;;
    *)
      print_help
      exit 0
      ;;
  esac
done
shift $(($OPTIND - 1))

GITVERSION=$(git describe --long --abbrev=10)
GITVERSION=$(echo "${GITVERSION}"|sed 's%\(.*-[[:digit:]]\+-\)\(g\)\(.\{10\}$\)%\1\3%') #removing 'g' from git tag
ENVFILE=".envversion.txt"

echo "generating environ version file ${ENVFILE}, id string will be ${GITVERSION}"
echo "${GITVERSION}" > "${ENVFILE}"
for i in .bashrc bin .profile .bash_profile .screenrc .vimrc .vim .gitconfig .hgrc .tmux.conf "${ENVFILE}" ;do
    if [ "x${DOWRITE}" == "xYES" ];then
        cp -av ${i} ~/
    fi
    if [ "x${DOCHECK}" == "xYES" ];then
        diff -Naur "${i}" ~/"${i}"
    fi
done
