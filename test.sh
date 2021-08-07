#!/bin/sh

# test..
password="password"
gitTest="https://github.com/LukeSmithxyz/st.git"
# script variables....
dotFilesRepo="https://github.com/ayman-rahmon/MyConfig.git"
dotRepoBranch="main"
userName="placeHolder"

aurHelperRepo="https://aur.archlinux.org/paru.git"
getUserAndPass(){
# prompt the user to enter their userName and validate it...
read -p 'UserName: ' userName
while !  echo "$userName" | grep -q "^[a-z_][a-z0-9_-]*$" ; do
 	read -p 'userName not valid please start the username with a letter and contains only letters and numbers: ' userName
done ;
# prompt the user to Enter the password and validate it...
read -sp 'Enter New Password : ' password
printf "\n"
read -sp 'Repeat New Password: ' password2
while ! [ "$password" = "$password2" ]; do
	printf "\n"
	printf "passwords don't match, try again!"
	printf "\n"
	read -sp 'Enter New Password : ' password
	printf "\n"
	read -sp 'Repeat New Password: ' password2

done;
}


addUserAndPass(){
useradd --create-home -m -g wheel -s /bin/zsh "$userName" > /dev/null
echo "$userName:$password" | chpasswd
unset password password2 ;
}
setUpConfigs2(){
	# check if the branch was inputed and if not use the default branch
	#[ -z "$3" ] && branch="main" || branch="$dotRepo"
	# check if the user exists and the directory for it exist...
	#[ ! -d "$2"] && mkdir -p "$2"]
	# clone repo...
	repoName=$(basename $1 .git)
 	# copying everything in the target folder...
	(git clone "$1" && cd "$repo" && cp  -r * "$2" )
	# cleaning up...
	rm -rf $repoName
}
setUpConfigs(){
# add more config files to the system...
echo 'hello there2...'
	[ -z "$3" ] && branch="main" || branch="$dotRepoBranch"
	dir=$(mktemp -d)
	[ ! -d "$2" ] && mkdir -p "$2"
	chown tatsujin:wheel "$dir" "$2"
	sudo -u tatsujin git clone --recursive -b "$branch" --depth 1 --recurse-submodules "$1" "$dir" #> /dev/null 2>&1
	sudo -u tatsujin cp -rfT "$dir" "$2"
}



manualinstall() { # Installs $1 manually if not installed. Used only for AUR helper here.
	[ -f "/usr/bin/$1" ] || (
	dialog --infobox "Installing \"$1\", an AUR helper..." 4 50
	cd /tmp || exit 1
	rm -rf /tmp/"$1"*
	curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
	sudo -u "$name" tar -xvf "$1".tar.gz >/dev/null 2>&1 &&
	cd "$1" &&
	sudo -u "$name" makepkg --noconfirm -si >/dev/null 2>&1 || return 1
	cd /tmp || return 1) ;}



gitInstall() {
	# consider keeping the source somewhere in the system later (for suckless programs)...
	repoName=$(basename $1 .git)
	printf "installing $repoName ..."

	#(git clone $1 && cd $repoName && make > /dev/null && make install > /dev/null)
	(git clone $1 && cd $repoName && chown "$userName":wheel && sudo -u "$userName" makepkg -si )
	printf "cleaning up..."
	rm -rf $repoName
	printf "done installing $repoName ."
}



installingTheAURHelper() {
	# consider keeping the source somewhere in the system later (for suckless programs)...
	repoName=$(basename $1 .git)
	printf "installing $repoName ..."

	#(git clone $1 && cd $repoName && make > /dev/null && make install > /dev/null)
	(git clone $1 && cd $repoName && sudo -u "$userName" makepkg -si )
	printf "cleaning up..."
	rm -rf $repoName
	printf "done installing $repoName ."
}


#gitInstall https://aur.archlinux.org/paru.git
echo 'hello there...'
getUserAndPass
#setUpConfigs "$dotFilesRepo" "/home/$userName" "$dotRepoBranch"
# putgitrepo $dotFilesRepo "/home/tatsujin/temp" "$dotRepo"
installingTheAURHelper $aurHelperRepo
# testing the paru installation thingy (AUR installation)...
# sudo -u tatsujin paru -S --noconfirm google-chrome-dev >/dev/null 2>&1
# getUserAndPass
# addUserAndPass #pacman --noconfirm -S --needed python-cpplint 2>&1
