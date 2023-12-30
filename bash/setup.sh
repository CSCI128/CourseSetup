#!/bin/zsh

reload_env ()
{
    if [[ $SHELL == '/bin/zsh' ]]; then
        source ~/.zshrc

    else
        source ~/.bashrc
    fi
    
}

install_python () 
{
    echo "Installing Python 3.11..."
    # This might be a problem spot
    brew install python@3.11

    if [[ $SHELL == '/bin/zsh' ]]; then
        echo "alias python=python3" >> ~/.zshrc
        echo "alias pip=pip3" >> ~/.zshrc

    else
        echo "alias python=python3.11" >> ~/.bashrc
        echo "alias pip='python -m pip'" >> ~/.bashrc
    fi

}

echo "This script installs brew (the macos package manager), python, and vscode."
echo "You will be asked for your password to install the brew. There won't be any output when you enter it, but don't worry\!"

echo "Press any key to start installation!"

read 

echo "Checking if brew is already installed..."
brew --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Brew is not installed! Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Brew is installed!"

reload_env

echo "checking to see if python 3.10 or higher is installed..."

python --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    install_python

elif ! python -c 'import sys; assert sys.version_info >= (3,10)' > /dev/null; then
    install_python
fi

reload_env

echo "Installing class dependancies"
pip install matplotlib

echo "Installing autograder dependancies"
pip install -r https://raw.githubusercontent.com/CSCI128/128Autograder/main/source/requirements.txt

reload_env

echo "Checking if vscode is installed"
code --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "VS code is not installed! Installing..."
    echo "If you have already installed vs code, nothing will be modified."
    brew install --cask visual-studio-code
fi

echo "vscode installed! Course setup complete!"
