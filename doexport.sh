#!/bin/bash
tmpdir=$(mktemp -d -t svnexport.XXXXXX) || exit 1
echo "doing export into ${tmpdir}"
svn export --force . ${tmpdir}
cd ${tmpdir}
for i in .bashrc bin .profile .bash_profile .screenrc .vimrc .vim .gitconfig .hgrc .tmux.conf ;do
    cp -av ${i} ~/
done
rm -rf ${tmpdir}
