#!/bin/zsh

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

echo "Adding brew to path"

echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc && source ~/.zshrc
echo "export Path=/usr/local/bin:$PATH" >> ~/.zshrc && source  ~/.zshrc


source ~/.zshrc

echo "checking to see if python 3.11 or higher is installed..."

python --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Installing Python 3.12..."
    brew install python@3.12

    echo "alias python=python3.12" >> ~/.zshrc
    echo "alias pip='python -m pip'" >> ~/.zshrc


elif ! python -c 'import sys; assert sys.version_info >= (3,11)' > /dev/null; then
    echo "Installing Python 3.12..."
    brew install python@3.12

    echo "alias python=python3.12" >> ~/.zshrc
    echo "alias pip='python -m pip'" >> ~/.zshrc
fi

source ~/.zshrc

python --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo 'Python installation failed! Please reach out on Ed with a screenshot of this error (and the lines proceeding it) to get help.'
    exit 1
fi

echo 'Python installed successfully!'


echo "Installing class dependancies"
pip install -r https://raw.githubusercontent.com/CSCI128/CourseSetup/main/requirements.txt

echo "Installing autograder dependancies"
pip install -r https://raw.githubusercontent.com/CSCI128/128Autograder/main/source/requirements.txt

source ~/.zshrc

echo "Checking if vscode is installed"
code --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Vscode is not installed! Installing..."
    echo "If you have already installed vs code, nothing will be modified."
    brew install --cask visual-studio-code

    if [ $? -ne 0 ]; then
        echo 'Unable to automatically install VS code. Please follow directions at this link under the "Installation" header: https://code.visualstudio.com/docs/setup/mac'
        exit 1
    fi
fi
echo "vscode installed!"

source ~/.zshrc

echo "Checking to see if vscode is on the path..."
code --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo 'Unable to automatically install python extension for VS code. Please follow directions at this link: https://marketplace.visualstudio.com/items?itemName=ms-python.python'
    exit 1
fi


code --install-extension ms-python.python

if [ $? -ne 0 ]; then
    echo 'Unable to automatically install python extension for VS code. Please follow directions at this link: https://marketplace.visualstudio.com/items?itemName=ms-python.python'
    exit 1
fi

echo "Course setup complete!"

