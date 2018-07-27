#! /bin/bash

# get default profile of gnome terminal
get_default_profile() {
	dconfdir=/org/gnome/terminal/legacy/profiles:
	profile_id="$(dconf read $dconfdir/default | \
		sed s/^\'// | sed s/\'$//)"
	if [[ $profile_id = '' ]]; then
		profile_id="$(dconf read $dconfdir/list | \
			sed s/^\\[\'// | sed s/\',.*//)"
	fi
	profile_name="$(dconf read $dconfdir/":"$profile_id/visible-name | \
		sed s/^\'// | sed s/\'$//)"
	echo $profile_name
} 

# fish installation
which fish > /dev/null
if [[ $? -ne 0 ]]; then
	sudo apt-add-repository -y ppa:fish-shell/release-2
	sudo apt update
	sudo apt install -y fish
fi

# install dependencies
sudo apt install -y curl git peco
fish -c "fd --version > /dev/null 2>&1"
if [[ $? -ne 0 ]]; then
	curl -LO https://github.com/sharkdp/fd/releases/download/v7.0.0/fd-musl_7.0.0_amd64.deb
	sudo dpkg -i fd-musl_7.0.0_amd64.deb
	rm fd-musl_7.0.0_amd64.deb
fi
fish -c "rgrep --version > /dev/null 2>&1"
if [[ $? -ne 0 ]]; then
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.8.1/ripgrep_0.8.1_amd64.deb
	sudo dpkg -i ripgrep_0.8.1_amd64.deb
	rm ripgrep_0.8.1_amd64.deb
fi

# fisherman installation
fish -c 'fisher --quiet'
if [[ $? -ne 0 ]]; then
	curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
fi

# theme installation
theme='bobthefish'
fish -c "fisher install omf/theme-$theme"

# plugin installation
# peco for history
fish -c "fisher install omf/peco fnm nyarly/fish-rake-complete edc/bass tuvistavie/fish-fastdir yoshiori/fish-peco_select_ghq_repository fzf"

# font installation
fc-list | grep 'Source Code Pro for Powerline' > /dev/null
if [[ $? -ne 0 ]]; then
	git clone https://github.com/powerline/fonts.git --depth=1
	cd fonts/
	./install.sh
	cd ..
	rm -rf fonts

	# change gnome-terminal font
fi

# color theme installation
# get active profile of gnome-terminal
profile="$(get_default_profile)"
if [[ ! -f ~/.dir_colors/dircolors ]]; then
	git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
	cd gnome-terminal-colors-solarized
	./install.sh -s dark -p "$profile" --install-dircolors
	cd ..
	rm -rf gnome-terminal-colors-solarized
fi

# configuration file download
