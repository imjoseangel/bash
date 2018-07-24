#!/usr/bin/env bash

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st "status -sb"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.lol "log --graph --decorate --oneline"
git config --global alias.lola "log --graph --decorate --oneline --all"
