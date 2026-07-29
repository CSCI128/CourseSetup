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

echo "Installing Python 3.13..."
brew install python@3.13

echo "alias python=python3.13" >> ~/.zshrc
echo "alias pip='python -m pip'" >> ~/.zshrc


source ~/.zshrc

python --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo 'Python installation failed! Please reach out on Ed with a screenshot of this error (and the lines proceeding it) to get help.'
    exit 1
fi

echo 'Python installed successfully!'

source ~/.zshrc

echo "Installing class dependancies"
pip install -r https://raw.githubusercontent.com/CSCI128/CourseSetup/main/requirements.txt --break-system-packages

echo "Installing 128Autograder"
pip install 128Autograder --break-system-packages

source ~/.zshrc

echo "Verifing autograder installed correctly..."

test_my_work --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Autograder failed to install!"
    echo "Try running pip install '128Autograder --break-system-packages' and then running the script again."
    echo 'Reach out on Ed with questions!'
    exit 1
fi

pip install matplotlib --break-system-packages

echo "Checking if VSCodium is installed"
codium --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Vscodium is not installed! Installing..."
    echo "If you have already installed VSCodium, nothing will be modified."
    brew install --cask vscodium

    if [ $? -ne 0 ]; then
        echo 'Unable to automatically install VSCodium. Please download and install the MacOS .dmg file linked here: https://github.com/VSCodium/vscodium/releases'
        exit 1
    fi
fi
echo "VSCodium installed!"

source ~/.zshrc

echo "Checking to see if VSCodium is on the path..."
codium --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo 'Unable to automatically install python extension for VSCodium. Please run VSCodium and install the Python extension manually'
    exit 1
fi


codium --install-extension ms-python.python

if [ $? -ne 0 ]; then
    echo 'Unable to automatically install python extension for VSCodium. Please run VSCodium and install the Python extension manually'
    exit 1
fi

echo "Course setup complete!"

