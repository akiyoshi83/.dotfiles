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
mkdir -p ~/.vim/tmp

# neivim
ln -s ~/.dotfiles/.vim ~/.config/nvim
ln -s ~/.dotfiles/.vimrc ~/.config/nvim/init.vim

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# tmux
ln -s ~/.dotfiles/.tmux.conf ~/

