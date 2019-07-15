#!/bin/env sh
echo Installing dependencies...
sudo dnf install -y \
	clang-tools-extra \
	git-all \
	python3-jedi \
	python3-virtualenv \
	python-jedi \
	python-lldb \
	python-virtualenv \
	the_silver_searcher \
	xsel \
	${NULL}

echo Setting up python venv

mkdir -p ~/.config/nvim/
pushd ~/.config/nvim
virtualenv --python=python3 ./pyenv3
pyenv3/bin/pip install --upgrade neovim
virtualenv --python=python2 ./pyenv2
pyenv2/bin/pip install --upgrade neovim
popd

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
