# .bashrc
if [ -z "$BASHRCSOURCED" ]; then
    export BASHRCSOURCED="Y"
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

if [ -f ~/.nb_bashrc ]; then
    source ~/.nb_bashrc
fi
#
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
#
# Amethyst stuff
#
function pssh()
{
  cp $(cat /tmp/am_cert_keypath) /tmp/am-vm.id
  chmod 600 /tmp/am-vm.id
  ssh p0-hs1-h$1
}
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
        #do things
        export IN_BASHRC_NVIM="y"
        # Git branch support
        [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ] && source /usr/share/git-core/contrib/completion/git-prompt.sh
        [ -f /usr/share/bash-completion/completions/git ] && source /usr/share/bash-completion/completions/git

        source ~/.nb_bashrc
    fi

