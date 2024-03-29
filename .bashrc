# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=50000
HISTSIZE=50000


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[36m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias tma="tmux attach || tmux"
alias tns="tmux new-session"
alias tmuxenvstart="_tmux_env_start"
function tmw {
    tmux split-window -dh "$*"
}
function _tmux_env_start {
    #set -x
    local ENV_TMUXSETUPCONFIG=${TMUXSETUPCONFIG:-}
    local ARG_TMUXSETUPCONFIG="$1"
    local DEFAULT_TMUXSETUPCONFIG=".tmux.setupconfig.sh"

    # order of precedence:
    # * CLI arg
    # * ENV var - expected to be used with 'direnv'
    # * default value
    #
    # if value is present but file doesn not exist - do nothing
    local _TMUXSETUPCONFIG="${DEFAULT_TMUXSETUPCONFIG}"
    local _TMUXSETUPCONFIG="${ENV_TMUXSETUPCONFIG:-$_TMUXSETUPCONFIG}"
    local _TMUXSETUPCONFIG="${ARG_TMUXSETUPCONFIG:-$_TMUXSETUPCONFIG}"
    #set +x

    if [ -f "$_TMUXSETUPCONFIG" ];then
        if ! . "$_TMUXSETUPCONFIG" ;then
            echo "cannot run config file $_TMUXSETUPCONFIG . Check permissions?"
            #exit 2
        fi
    else
        echo "specified config file $_TMUXSETUPCONFIG ( $(realpath "${_TMUXSETUPCONFIG}") ) cannot be found"
        #exit 2
    fi

#    echo "tmux config: ${_TMUXSETUPCONFIG}"

#### config example ####
##!/bin/bash
#SUBPROJDIR='infra/tests/puppet-tests/puppet-mutagen/'
#cd "$SUBPROJDIR" || exit 2
#tmux new-session -d -s puppet 'bash'
#tmux new-window
#tmux new-window
#tmux new-window
#tmux new-window
#tmux new-window
#tmux send 'cd ../puppet-enc' ENTER
#tmux rename-window -t 6 'enc'
#tmux select-window -t 1
#tmux attach;
}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#adding path
NEWPATH=/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/usr/sbin:/opt/java/bin:/opt/sun/mq/bin
PATH=$PATH:$NEWPATH
export PATH

# checking for lesspipe
# debian has lesspipe , while centos has lesspipe.sh . other may have something strange too
if which lesspipe 1>/dev/null 2>/dev/null;then
    eval $(lesspipe)
elif which lesspipe.sh 1>/dev/null 2>/dev/null;then
    LESSOPEN="|lesspipe.sh %s"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin/" ] ; then
    PATH="$HOME/.local/bin/:$PATH"
fi


#complete ssh hosts
#Taken from https://blog.petdance.com/2019/10/31/tab-completion-for-ssh-scp/
__complete_ssh_host() {
    local KNOWN_FILE=~/.ssh/known_hosts
    if [ -r $KNOWN_FILE ] ; then
        #local KNOWN_LIST=`cut -f 1 -d ' ' $KNOWN_FILE | cut -f 1 -d ',' | grep -v '^[0-9[]'`
        #grepping out the hashed hosts
        #regular format: host.example.com,1.2.3.4 ssh-rsa AAA...ZZZ==
        #hashed: |1|agMU+WHZHQo6F7tsy3YpftK .....
        local KNOWN_LIST=`cut -f 1 -d ' ' ~/.ssh/known_hosts | grep -v '^\|'| cut -f 1 -d ',' | grep -v '^[0-9[]'`
    fi

    # main config
    local CONFIG_FILE=~/.ssh/config
    if [ -r $CONFIG_FILE ] ; then
        local CONFIG_LIST=`awk '/^Host [A-Za-z]+/ {print $2}' $CONFIG_FILE`
    fi
    # includes for ssh
    local CONFIG_FILE=~/.ssh/includes
    if [ -d $CONFIG_FILE ] ; then
        local CONFIG_LIST+=`awk '/^Host [A-Za-z]+/ {print $2}' ${CONFIG_FILE}/*.conf`
    fi

    local PARTIAL_WORD="${COMP_WORDS[COMP_CWORD]}";

    COMPREPLY=( $(compgen -W "$KNOWN_LIST$IFS$CONFIG_LIST" -- "$PARTIAL_WORD") )

    return 0
}

complete -F __complete_ssh_host ssh
#my own alias for ssh - `s`
complete -F __complete_ssh_host s
complete -f -F __complete_ssh_host scp


EDITOR=vim
export EDITOR

#saving history
if ! [ -z "$PROMPT_COMMAND" ];then
  PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
else
  PROMPT_COMMAND="history -a"
fi

#debian email for dch(1)
export DEBEMAIL='coolthecold@gmail.com'

#Setting separate history for for root mode:
if [ $(id -u) == "0" ];then HISTFILE=~/.bash_history-root;fi


#eval "$(/home/coolcold/.chefvm/bin/chefvm init -)"
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

