# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/login.defs
#umask 022

# Predictable SSH authentication socket location - useful under tmux/screen.
#SOCK="/tmp/ssh-agent-$USER-screen"
#due to https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/sysctl/fs.txt?id=refs/tags/v3.19#n182 aka protected symlinks, root cannot use user's ssh auth with 1777 mode on /tmp
SOCKDIR="/tmp/${USER}"
SOCK="${SOCKDIR}/ssh-agent-$USER-screen"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ] && [ -z "$TMUX" ]
then
    mkdir -m 0770 -p "${SOCKDIR}" && rm -f ${SOCK} && \
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
fi

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

