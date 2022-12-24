# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth
export GPG_TTY=`tty`

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -Al'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Added by Andries Filmer
#########################
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

# Filenames with space showing as 'file name' after upgrade to 18.04
export QUOTING_STYLE=literal

alias ...='cd ../../'
alias dfx='df -h -x squashfs -x tmpfs -x devtmpfs'
alias passAndries="gpg -r andries -d .gnupg/andries.gpg | grep -i "
alias passwordAndries="gnome-gpg -r andries -d .gnupg/andries.gpg | grep -i "
alias keepass="~/gtd/scripts/sh/keepass.sh"
alias keepass-cli="~/gtd/scripts/sh/keepass-cli.sh"
alias myserver="~/gtd/scripts/perl/my-servers.pl"
#alias spotify="/usr/bin/spotify --force-device-scale-factor=1.5"
alias gitlog="git log --branches --not --remotes"
#alias gitdiff="git diff --branches --not --remotes"
alias gitdiff="git difftool --tool=vimdiff"
#alias adb="~/Android/Sdk/platform-tools/adb"

# Open broot with uncommitted files for git. Open with F2
alias brapp="cd ~/dev/inzetrooster-app/ && broot -gc :gs"
alias railss="cd ~/dev/inzetrooster-app/ && rails s"

# Automatic LS after change directory
cdl () {
  cd "$@" && ls -altr
}

backup () {
  cp "$@" "$@".backup-`date +'%Y-%m-%m_%H:%M'`;
}

genpasswd() {
  local l=$1
  [ "$l" == "" ] && l=16
  tr -dc [:alnum:] < /dev/urandom | head -c ${l} | xargs
}

#export ANDROID_HOME=/home/andries/Android/Sdk/
#PATH=$PATH:/home/andries/Android/Sdk/
#PATH=$PATH:/opt/android-studio/gradle/gradle-4.1/bin/
#export ANDROID_HOME="$HOME/Android/Sdk"
#PATH=$PATH:$ANDROID_HOME/tools; PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH
export EDITOR='vim'
