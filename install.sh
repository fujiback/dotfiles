#!/bin/sh

symbolic_link(){
  ln -ivs $1 $2
}

download(){
  if [ ! -e $1 ]; then
    wget -O $1 $2
  fi
}

DOTFILES_ROOT=$(cd $(dirname $0); pwd)

download $DOTFILES_ROOT/.emacs.d/moccur-edit.el "http://www.emacswiki.org/emacs/download/moccur-edit.el"

symbolic_link $DOTFILES_ROOT/.zshrc ~/
symbolic_link $DOTFILES_ROOT/.emacs.d ~/

