cd ~
git clone https://github.com/akiyoshi83/.dotfiles.git

echo "source \$HOME/.dotfiles/.profile" >> ~/.bashrc

# vim
ln -s ~/.dotfiles/.vimrc ~/
ln -s ~/.dotfiles/.vim   ~/
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/tmp

# NeoBundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
vim +":NeoBundleInstall" +:q
(cd ~/.dotfiles/.vim/bundle/vimproc/ && make)

# gem
ln -s ~/.dotfiles/.gemrc ~/

# git
cat << EOF >> ~/.gitconfig
[include]
	path = ~/.dotfiles/.gitconfig
EOF

