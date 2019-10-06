if (Test-Path "~/.dotfiles") {
    echo "~/.dotfiles already exists."
    exit 1
}

cd ~
git clone https://github.com/akiyoshi83/.dotfiles.git

# git
$gitconfig = @"
[include]
	path = ~/.dotfiles/.gitconfig
"@
echo $gitconfig | Out-File -Append -Encoding UTF8 ~/.gitconfig

# vim
New-Item -ItemType junction -Path $HOME -Name .vim -Value $HOME\.dotfiles\.vim
New-Item -ItemType hardlink -Path $HOME -Name .vimrc -Value $HOME\.dotfiles\.vimrc
mkdir -p $HOME/.vim/tmp

# neivim
New-Item -ItemType junction -Path $HOME\AppData\Local -Name nvim -Value $HOME\.dotfiles\.vim
New-Item -ItemType hardlink -Path $HOME\AppData\Local\nvim -Name init.vim -Value $HOME\.dotfiles\.vimrc

# vim-plug
$vimPlugUrl = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
(New-Object net.webclient).DownloadFile($vimPlugUrl, "$HOME\.vim\autoload\plug.vim")
New-Item -ItemType Directory $HOME\.local\share\nvim\site\autoload
(new-object net.webclient).DownloadFile($vimPlugUrl, "$HOME\.local\share\nvim\site\autoload\plug.vim")

# Keyhac
New-Item -ItemType Directory $HOME\AppData\Roaming\Keyhac
New-Item -ItemType hardlink -Path $HOME\AppData\Roaming\Keyhac -Name config.py -Value $HOME\.dotfiles\Keyhac\config.py
