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
	printf 'this script will help you rice your fresh arch install very easily with a minimal amount of effort.'
	printf 'we just need to ask you some questions and then the rest will be fully automated...'



}

# get the username and password...
# tested...Done.
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

# tested...Done.
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
sudo -u "$username" $aurHelper  -S --noconfirm $1 >/dev/null 2>&1
}

pacmanInstall(){
pacman --noconfirm -S --needed $1 2>&1
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
		pacmanInstall $package

	elif [ $source == 'aur' ] ; then
		# tested...Done.
		installAURHelper $package

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
# making sure that the script was started by the root user...
pacman --noconfirm --needed -Sy || error "please make sure to run this script as root user..."
# print out the introduction...
introduction || error "user exited..."
# getting the user and pass information...
getUserAndPass || error "user exited..."
#(TODO) probably it's a good idea to add some break for the user hear to confirm and start the process...

# make sure that some base packages are installed ...
for x in base-devel git ntp zsh curl; do
	pacmanInstall "$x"
done

# synchronizing the system time... (TODO) test with and without... for later...
ntpdate 0.us.pool.ntp.org >/dev/null 2>&1

# add user and password...
addUserAndPass || error "problem adding the user or the password..."

# allow user to run sudo...



# change pacman and paru themes...


# use all the cores for compilation...



# check and install the AURHelper code...


# installation loop...



# downloading ang setting up  the config files...

# delete extra files from the home (that came from the config being cloned in home) ...





}



################# start of functional programming... #################
main
