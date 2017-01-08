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

# dein.vim
if [ ! -e ~/.cache/dein ]; then
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein-installer.sh
    sh ./dein-installer.sh ~/.cache/dein
    rm -f ./dein-installer.sh
fi
vim +":call dein#install()" +:q

# tmux
ln -s ~/.dotfiles/.tmux.conf ~/

