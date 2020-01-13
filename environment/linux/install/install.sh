#!/bin/bash

sudo apt update 
sudo apt install vim -y
sudo apt install g++ -y
sudo apt install gcc -y
sudo apt install g++-5 -y
sudo apt install gcc-5 -y
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 100
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 100
sudo update-alternatives --config gcc
sudo update-alternatives --config g++
sudo apt install redis -y
sudo apt install mysql-client -y
sudo apt install mysql-server -y
sudo apt install git -y
git config --global user.name "mazhuang"
git config --global user.email "1234.mail"
git config --global core.editor vim
