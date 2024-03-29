#! /bin/bash

ln -isT ~/dotfiles/.vimrc ~/.vimrc
ln -isT ~/dotfiles/.bashrc ~/.bashrc
ln -isT ~/dotfiles/.bash_profile ~/.bash_profile
ln -isT ~/dotfiles/.bash_aliases ~/.bash_aliases
ln -isT ~/dotfiles/.direnvrc ~/.direnvrc
ln -isT ~/dotfiles/.vim ~/.vim
ln -isT ~/dotfiles/.gitcommit ~/.gitcommit
ln -isT ~/dotfiles/.gitconfig ~/.gitconfig
ln -isT ~/dotfiles/.gitignore_global ~/.gitignore_global
ln -isT ~/dotfiles/.xbindkeysrc ~/.xbindkeysrc
ln -isT ~/dotfiles/.ctags ~/.ctags
ln -isT ~/dotfiles/.tigrc ~/.tigrc
ln -isT ~/dotfiles/.tigrc.large ~/.tigrc.large
ln -isT ~/dotfiles/.config/byobu ~/.config/byobu
ln -isT ~/dotfiles/.config/byobu/.tmux.conf ~/.tmux.conf
ln -isT ~/dotfiles/.config/fusuma ~/.config/fusuma
ln -isT ~/dotfiles/.config/xremap ~/.config/xremap
ln -isT ~/dotfiles/.config/ranger ~/.config/ranger
ln -isT ~/dotfiles/.config/ansible ~/.config/ansible
ln -isT ~/dotfiles/.config/autostart ~/.config/autostart
ln -isT ~/dotfiles/.config/alacritty ~/.config/alacritty
ln -isT ~/dotfiles/.config/efm-langserver ~/.config/efm-langserver

git clone https://github.com/erikw/tmux-powerline.git ~/dotfiles/.config/byobu/tmux-powerline
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
