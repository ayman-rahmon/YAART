#bin/bash
# this script is written by Ayman Rahmon and it was designed to be run from the root user of a fresh installed arch linux system...


# dot files variables...
dotFilesRepo=https://github.com/ayman-rahmon/MyConfig.git
dotRepo="main"
# script variables...
programsTable="programs.csv"
aurHelper="paru"
aurHelperRepo="https://aur.archlinux.org/paru.git"
environment="i3-wm" # this is for later when i add more options for the users to install more set ups...


introduction() {
	printf 'welcome to the YAART script for auto ricing.\n'
	printf 'this script will help you rice your fresh arch install in a very easy and possibly minimalist way.'



}

# get the username and password...
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
useradd --create-home -m -g wheel -s /bin/zsh "$username" > /dev/null
echo "$username:$password" | chpasswd
unset password password2 ;
}
# this works with a package that has PKGBUILD file... (will fix it to work with make files later)...
# tested... Done.
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

installAURHelper() {
	# method to install AUR Helper...



}



# installs all the packages in the table with the appropriate method of installation
installPackages() {
# check if our aur helper is installed...
if [ $(pacman -Qqm | grep $aurHelper) == "$aurHelper" ]; then

	echo 'now we can start working on installing packages since yay is installed...'
else
	gitInstall $aurHelperRepo
fi


pacman --noconfirm -Syu
# reading from a csv file and actually installing packages...
sed 1d $programsTable | while IFS=, read  source package description
do
	# echo "$source \t $package \t $description"


	if [ $source == 'pacman' ] ; then
		printf "installing $package which is a : $description"
		# tested...Done.
		pacman --noconfirm -S --needed $package 2>&1

	elif [ $source == 'aur' ] ; then
		# tested...Done.
		sudo -u "$username" $aurHelper  -S --noconfirm $package >/dev/null 2>&1

	elif [ $source == 'Git' ] ; then
		# tested...Done.
		gitInstall $package

	fi

done < $programsTable



}

# tested... Done.
setUpConfigs(){
# add more config files to the system...
	[ -z "$3" ] && branch="main" || branch="$dotRepo"
	dir=$(mktemp -d)
	[ ! -d "$2" ] && mkdir -p "$2"
	chown "$username":wheel "$dir" "$2"
	sudo -u "$username" git clone --recursive -b "$branch" --depth 1 --recurse-submodules "$1" "$dir" >/dev/null 2>&1
	sudo -u "$username" cp -rfT "$dir" "$2"}



main() {
# setting up everything to run on the right time...



# allow user to use sudo...




}



################# start of functional programming... #################
main
