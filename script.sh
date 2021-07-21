#bin/bash
# this script is written by Ayman Rahmon and it was designed to be run from the root user of a fresh installed arch linux system...


# variables and choices...
dotFilesRepo=https://github.com/ayman-rahmon/MyConfig.git
programsTable="programs.csv"
aurHelper="yay-git"
aurHelperRepo="https://aur.archlinux.org/yay.git"
environment="i3-wm" # this is for later when i add more options for the users to install more set ups...

introduction() {



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
aurInstall() {
	# consider keeping the source somewhere in the system later (for suckless programs)...
	repoName=$(basename $1 .git)
	(git clone $1 && cd $repoName && makepkg -si)
	rm -rf $repoName
}



# installs all the packages in the table with the appropriate method of installation
installPackages() {
# check if our aur helper is installed...
if [ $(pacman -Qqm | grep yay-git) == "yay-git" ]; then

	echo 'now we can start working on installing packages since yay is installed...'
else
	aurInstall $aurHelperRepo
fi


pacman --noconfirm -Syu
# reading from a csv file and actually installing packages...
sed 1d $programsTabe | while IFS=, read  source package description
do
	# echo "$source \t $package \t $description"


	if [ $source == 'pacman' ] ; then
		printf "installing $package which is a : $description"
		pacman --noconfirm -S $package

	elif [ $source == 'aur' ] ; then
		sudo -u $username yay  -S $package

	elif [ $source == 'Git' ] ; then
		aurInstall $package

	fi

done < $programsTabe



}


setUpConfigs(){
repoName=$(basename $repo .git)
git clone $dotFilesRepo
mv $repoName/* /home/$username/.config

}







################# start of functional programming... #################


# update all the databases and the system...
# setting up ~/.xinitrc in the user's home...
# echo "exec i3" >> /home/$username/.xinitrc



# st configurations...


# clonning and copying all of the config files to their correct location for the user...
