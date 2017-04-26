# .bash_profile

# Get the aliases and functions
#if [ -f ~/.bashrc ]; then
#	. ~/.bashrc
#fi

# User specific environment and startup programs

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
unalias ll
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

#
## Keep history from different terminals and TMUX sessions
#
# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups

# append history entries..
shopt -s histappend

# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

## End for History configuration
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
export PS1
