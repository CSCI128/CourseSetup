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

echo "Installing Python 3.12..."
brew install python@3.12

echo "alias python=python3.12" >> ~/.zshrc
echo "alias pip='python -m pip'" >> ~/.zshrc


source ~/.zshrc

python --version > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo 'Python installation failed! Please reach out on Ed or to Gregory Bell (gjbell@mines.edu) with a screenshot of this error (and the lines proceeding it) to get help.'
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

if [$? -ne 0]; then
    echo "Autograder failed to install!"
    echo "Try running pip install '128Autograder --break-system-packages' and then running the script again."
    echo 'Reach out on Ed or to Gregory Bell (gjbell@mines.edu) with questions!'
    exit 1
fi


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

