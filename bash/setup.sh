#!/bin/bash

reload_env ()
{
    if [[ $SHELL == '/bin/zsh' ]]; then
        source ~/.zshrc

    else
        source ~/.bashrc
    fi
    
}

echo "This script installs the xcode command line tools, brew (the macos package manager), python, and vscode."
echo "You will be asked for your password to install the command line tools and brew. There won't be any output when you enter it, but don't worry\!"

echo "Press any key to start installation!"

read 

echo "Checking to see if xcode command line tools are already installed..."
if [[ ! $(pkgutil --pkg-info=com.apple.pkg.CLTools_Executables) ]]; then
    echo "Xcode command line tools are not installed! Installing..."
    sudo xcode-select --install

fi

echo "Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

reload_env

echo "Installing Python..."
brew install python@3.11

if [[ $SHELL == '/bin/zsh' ]]; then
    echo "alias python=python3" >> ~/.zshrc
    echo "alias pip=pip3" >> ~/.zshrc

else
    echo "alias python=python3" >> ~/.bashrc
    echo "alias pip=pip3" >> ~/.bashrc
fi

reload_env

echo "Installing class dependancies"
pip install matplotlib

echo "Installing autograder dependancies"
pip install -r https://raw.githubusercontent.com/CSCI128/128Autograder/main/source/requirements.txt

reload_env

echo "Checking if vscode is installed"
if [[ ! $(code --version >/dev/null 2>&1) ]]; then
    echo "VS code is not installed! Installing..."
    brew install --cask visual-studio-code
fi

echo "vscode installed! Course setup complete!"
