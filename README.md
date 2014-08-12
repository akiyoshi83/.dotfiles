dotfiles
========

My dot files.

install
-------

```sh
cd ~
git clone git@github.com:akiyoshi83/dotfiles.git

echo "source \$HOME/dotfiles/.profile" >> ~/.bashrc

ln -s ~/dotfiles/.gemrc ~/

ln -s ~/dotfiles/.vimrc ~/
ln -s ~/dotfiles/.vim   ~/
mkdir -p ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

# if use golang
# see https://github.com/nsf/gocode#vim-setup
```

