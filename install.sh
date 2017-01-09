if [ -e ~/.dotfiles ]; then
    echo "~/.dotfiles already exists."
    exit 1
fi

cd ~
git clone https://github.com/akiyoshi83/.dotfiles.git
echo "source \$HOME/.dotfiles/.profile" >> ~/.bashrc

# gem
ln -s ~/.dotfiles/.gemrc ~/

# git
cat << EOF >> ~/.gitconfig
[include]
	path = ~/.dotfiles/.gitconfig
EOF

# vim
ln -s ~/.dotfiles/.vimrc ~/
ln -s ~/.dotfiles/.vim   ~/
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/tmp

# vim NeoBundle
if [ ! -e ~/.vim/bundle/neobundle.vim ]; then
    git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi
vim +":NeoBundleInstall" +:q

# tmux
ln -s ~/.dotfiles/.tmux.conf ~/

