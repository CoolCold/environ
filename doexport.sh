#!/bin/bash

GITVERSION=$(git describe --long --abbrev=10)
GITVERSION=$(echo "${GITVERSION}"|sed 's%\(.*-[[:digit:]]\+-\)\(g\)\(.\{10\}$\)%\1\3%') #removing 'g' from git tag
ENVFILE=".envversion.txt"

echo "generating environ version file ${ENVFILE}, id string will be ${GITVERSION}"
echo "${GITVERSION}" > "${ENVFILE}"
for i in .bashrc bin .profile .bash_profile .screenrc .vimrc .vim .gitconfig .hgrc .tmux.conf "${ENVFILE}" ;do
    cp -av ${i} ~/
    #echo cp -av ${i} ~/
done
