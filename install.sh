#! /bin/bash

sudo apt install -y tmux tmux-plugin-manager fd-musl ripgrep

# Install go
curl -L https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz | sudo tar -C /usr/local -xz
cat <<EOS | sudo tee /etc/profile.d/go-lang.sh
export PATH=$PATH:/usr/local/go/bin
EOS

# Install ghq
go get github.com/motemen/ghq

# Install fzf
ghq get --shallow git@github.com:junegunn/fzf.git
cd ~/.ghq/github.com/junegunn/fzf
./install

# Install rust
curl https://sh.rustup.rs -sSf | sh
