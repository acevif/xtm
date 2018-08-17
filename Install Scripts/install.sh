echo "------------------------------------"
echo "Cloning Repo"
echo "------------------------------------"
mkdir ~/.xtm
cd ~/.xtm
git clone https://github.com/Camji55/Xcode-Template-Manager.git
echo "------------------------------------"
echo "Installing..."
echo "------------------------------------"
mv Xcode-Template-Manager/xtm/xtm /usr/local/bin/xtm
rm -rf ~/.xtm
echo "Installed!"
echo "------------------------------------"