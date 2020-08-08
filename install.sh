if [ -e ~/.dotfiles ]; then
    echo "~/.dotfiles already exists."
    exit 1
fi

cd ~
git clone https://github.com/akiyoshi83/.dotfiles.git

if [ "$SHELL" = "/bin/zsh" ]; then
    echo "source \$HOME/.dotfiles/shell/.zprofile" >> ~/.zprofile
    echo "source \$HOME/.dotfiles/shell/.zshrc" >> ~/.zshrc
else
    echo "source \$HOME/.dotfiles/shell/.bash_profile" >> ~/.bash_profile
    echo "source \$HOME/.dotfiles/shell/.bashrc" >> ~/.bashrc
fi

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

