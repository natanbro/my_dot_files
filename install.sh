#!/usr/bin/env bash
#
# Install the symbolic links on linux/mac
#
# assume you are running it from the cloned directory
#
if [ -f ~/.nb_bashrc ] ; then
	echo Renaming existing ~/.nb_bashrc to ~/.nb_bashrc.back
	cp ~/.nb_bashrc ~/.nb_bashrc.back
	rm ~/.nb_bashrc
fi
ln -s $PWD/nb_bashrc ~/.nb_bashrc
#
if [ -f ~/.tmux.conf ] ; then
	echo Renaming existing ~/.tmux.conf to ~/.tmux.conf.back
	cp ~/.tmux.conf ~/.tmux.conf.back
	rm ~/.tmux.conf
fi
ln -s $PWD/.tmux.conf ~/.tmux.conf
###
if [ -f ~/.bashrc ] ; then
	echo Renaming existing ~/.bashrc to ~/.bashrc.back
	cp ~/.bashrc ~/.bashrc.back
	rm ~/.bashrc
fi
ln -s $PWD/.bashrc ~/.bashrc
###
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
if [ -f ~/abbreviations.vim ] ; then
	echo Renaming existing ~/abbreviations.vim to ~/abbreviations.vim.back
	cp ~/abbreviations.vim ~/abbreviations.vim.back
	rm ~/abbreviations.vim
fi
ln -s $PWD/abbreviations.vim ~/abbreviations.vim
#
if [ -L ~/.vim ] ; then
	echo Renaming existing ~/.vim to ~/.vim.back
	mv ~/.vim ~/.vim.back
#	rm ~/.vim
fi
ln -s $PWD/vim ~/.vim
#
##git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
##
