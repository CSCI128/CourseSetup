sudo apt update
sudo apt-get install -y python3.12-full
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --break-system-packages
echo alias python=python3 >> ~/.bashrc
source ~/.bashrc
 
pip install 128Autograder --break-system-packages
pip install matplotlib --break-system-packages
 
sudo apt-get install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
 
sudo apt install -y apt-transport-https
sudo apt-get install -y code
 
code --install-extension ms-python.python
 
# Finally, you can verify everything worked by running:
code --version
python --version
test_my_work --version
pip --version
 
