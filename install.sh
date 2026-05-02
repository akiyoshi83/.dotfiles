if [ -e ~/.dotfiles ]; then
    echo "~/.dotfiles already exists."
    exit 1
fi

cd ~
git clone https://github.com/akiyoshi83/.dotfiles.git

safe_link() {
  local src=$1 dst=$2
  if [ -L "$dst" ]; then
    echo "Skipping $dst (symlink already exists)"
  elif [ -e "$dst" ]; then
    echo "WARNING: $dst exists and is not a symlink. Skipping."
  else
    ln -s "$src" "$dst"
  fi
}

if [ "$SHELL" = "/bin/zsh" ]; then
    echo "source \$HOME/.dotfiles/shell/.zprofile" >> ~/.zprofile
    echo "source \$HOME/.dotfiles/shell/.zshrc" >> ~/.zshrc
else
    echo "source \$HOME/.dotfiles/shell/.bash_profile" >> ~/.bash_profile
    echo "source \$HOME/.dotfiles/shell/.bashrc" >> ~/.bashrc
fi

# gem
safe_link ~/.dotfiles/.gemrc ~/.gemrc

# git
cat << EOF >> ~/.gitconfig
[include]
	path = ~/.dotfiles/.gitconfig
EOF

# vim
safe_link ~/.dotfiles/.vimrc ~/.vimrc
safe_link ~/.dotfiles/.vim   ~/.vim
mkdir -p ~/.vim/tmp

# neivim
safe_link ~/.dotfiles/.vim ~/.config/nvim
safe_link ~/.dotfiles/.vimrc ~/.config/nvim/init.vim

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# tmux
safe_link ~/.dotfiles/.tmux.conf ~/.tmux.conf
