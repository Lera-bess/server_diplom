#!/bin/bash

sudo apt update
sudo apt install git
git --version

git config --global user.email "lerik.becc@gmail.com"
git config --global user.email "lerik.becc"

sudo snap install phpstorm --classic

sudo apt install make

sudo apt-add-repository ppa:ansible/ansible
sudo apt install ansible