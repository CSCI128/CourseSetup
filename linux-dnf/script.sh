sudo dnf update -y
sudo dnf install -y python3.13
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --break-system-packages
echo alias python=python3 >> ~/.bashrc
source ~/.bashrc
 
pip install 128Autograder --break-system-packages
pip install matplotlib --break-system-packages
 
sudo dnf install -y wget gpg
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf check-update
sudo dnf install -y code
 
code --install-extension ms-python.python
 
# Finally, you can verify everything worked by running:
code --version
python --version
test_my_work --version
pip --version