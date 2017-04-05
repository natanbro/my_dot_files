#!/usr/bin/env bash
#
# Install the symbolic links on linux/mac
#
# assume you are running it from the cloned directory
#
if [ -f ~/.tmux.conf ] ; then
	echo Renaming existing ~/.tmux.conf to ~/.tmux.conf.back
	cp ~/.tmux.conf ~/.tmux.conf.back
	rm ~/.tmux.conf
fi
ln -s $PWD/.tmux.conf ~/.tmux.conf
#
if [ -f ~/.bash_profile ] ; then
	echo Renaming existing ~/.bash_profile to ~/.bash_profile.back
	cp ~/.bash_profile ~/.bash_profile.back
	rm ~/.bash_profile
fi
ln -s $PWD/.bash_profile ~/.bash_profile


