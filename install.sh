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
#
if [ -f ~/.vimrc ] ; then
	echo Renaming existing ~/.vimrc to ~/.vimrc.back
	cp ~/.vimrc ~/.vimrc.back
	rm ~/.vimrc
fi
ln -s $PWD/vimrc ~/.vimrc
#
if [ -f ~/.vimrc_bundles ] ; then
	echo Renaming existing ~/.vimrc_bundles to ~/.vimrc_bundles.back
	cp ~/.vimrc_bundles ~/.vimrc_bundles.back
	rm ~/.vimrc_bundles
fi
ln -s $PWD/vimrc_bundles ~/.vimrc_bundles
#
if [ -f ~/.vimrc_bundles_pre ] ; then
	echo Renaming existing ~/.vimrc_bundles_pre to ~/.vimrc_bundles_pre.back
	cp ~/.vimrc_bundles_pre ~/.vimrc_bundles_pre.back
	rm ~/.vimrc_bundles_pre
fi
ln -s $PWD/vimrc_bundles_pre ~/.vimrc_bundles_pre
#
if [ -L ~/.vim ] ; then
	echo Renaming existing ~/.vim to ~/.vim.back
	mv ~/.vim ~/.vim.back
#	rm ~/.vim
fi
ln -s $PWD/vim ~/.vim
#
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


