#!/bin/sh

dotRepo="main"
userName="placeHolder"
password="password"
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
echo "$username:$password" | chpasswd
unset password password2 ;
}
setUpConfigs(){
# add more config files to the system...
	[ -z "$3" ] && branch="main" || branch="$dotRepo"
	dir=$(mktemp -d)
	[ ! -d "$2" ] && mkdir -p "$2"
	chown tatsujin:wheel "$dir" "$2"
	sudo -u tatsujin git clone --recursive -b "&branch" --depth 1 --recurse-submodules "$1" "$dir" > /dev/null 2>&1
	sudo -u tatsujin cp -rfT "$dir" "$2"
}


putgitrepo() { # Downloads a gitrepo $1 and places the files in $2 only overwriting conflicts
	[ -z "$3" ] && branch="main" || branch="$dotRepo"
	dir=$(mktemp -d)
	[ ! -d "$2" ] && mkdir -p "$2"
	chown "$userName":wheel "$dir" "$2"
	sudo -u "$userName" git clone --recursive -b "$branch" --depth 1 --recurse-submodules "$1" "$dir" >/dev/null 2>&1
	sudo -u "$userName" cp -rfT "$dir" "$2"
	}


gitInstall() {
	# consider keeping the source somewhere in the system later (for suckless programs)...
	repoName=$(basename $1 .git)
	printf "installing $repoName ..."

	#(git clone $1 && cd $repoName && make > /dev/null && make install > /dev/null)
	(git clone $1 && cd $repoName && makepkg -si > /dev/null )
	printf "cleaning up..."
	rm -rf $repoName
	printf "done installing $repoName ."
}


#gitInstall https://aur.archlinux.org/paru.git
#setUpConfigs $dotFilesRepo "/home/tatsujin/temp" "main"
# putgitrepo $dotFilesRepo "/home/tatsujin/temp" "$dotRepo"

# testing the paru installation thingy (AUR installation)...
# sudo -u tatsujin paru -S --noconfirm google-chrome-dev >/dev/null 2>&1
getUserAndPass
addUserAndPass #pacman --noconfirm -S --needed python-cpplint 2>&1
