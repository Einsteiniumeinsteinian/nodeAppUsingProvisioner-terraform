#!/bin/bash

#variables
node_version='16.3'
app_name='Todo-App'
app_repo=https://github.com/Einsteiniumeinsteinian/${app_name}.git
# variable conditions
if [-z "$node_version"]; then
    node_version=node
fi

#update system
echo "Updating"
sudo apt update -y
echo "done"

#nvm installation 
echo 
echo 
echo "installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.nvm/nvm.sh
command -v nvm >/dev/null 2>&1 || {
    echo >&2 "nvm is required to continue but is not found.  Aborting Script.."
    exit 1
}
echo "done"

#node installation
echo
echo 
echo "installing node"
nvm install $node_version
command -v node >/dev/null 2>&1 || {
    echo >&2 "node is required to continue but is not found.  Aborting Script.."
    exit 1
}
echo "done"

#git installation
echo 
echo 
echo "installing git"
sudo apt install git
command -v git >/dev/null 2>&1 || {
    echo >&2 "git is required to continue but is not found.  Aborting Script.."
    exit 1
}
echo "done"

# node setup
echo
echo 
echo "cloning and building"
mkdir ~/apps
cd ~/apps/
git clone $app_repo
cd  $app_name
npm install
# npm run build
echo "done"

echo
echo
echo "serving site"
node app.js


echo "done"



echo "Script Success!!!"
