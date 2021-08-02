#bin/bash
# this script is written by Ayman Rahmon and it was designed to be run from the root user of a fresh installed arch linux system...


# dot files variables...
dotFilesRepo="https://github.com/ayman-rahmon/MyConfig.git"
dotRepoBranch="main"
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
# tested...Done.(also passed integration test)...
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

# tested...Done.(also passed integration testing)...
addUserAndPass(){
useradd --create-home -m -g wheel -s /bin/zsh "$userName" > /dev/null
echo "$userName:$password" | chpasswd
unset password password2 ;
}

# passed unit test and integration testing...
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
# test method...
gitmakeinstall() {
	progname="$(basename "$1" .git)"
	repodir="/home/$userName/.local/src"; mkdir -p "$repodir"; chown -R "$userName":wheel "$(dirname "$repodir")"
	dir="$repodir/$progname"
#	dialog --title "LARBS Installation" --infobox "Installing \`$progname\` ($n of $total) via \`git\` and \`make\`. $(basename "$1") $2" 5 70
	sudo -u "$userName" git clone --depth 1 "$1" "$dir"  || { cd "$dir" || return 1 ; sudo -u "$userName" git pull --force origin master;}
	cd "$dir" || exit 1
	sudo -u "$userName" makepkg -si
	# make install
	cd /tmp || return 1 ;}
# passed unit test and integration testing...
installAURHelper() {
	# method to install AUR Helper...
sudo -u "$username" $aurHelper  -S --noconfirm $1 >/dev/null 2>&1
}
# passed unit test and integration testing...
pacmanInstall(){
pacman --noconfirm -S --needed $1 2>&1
}
# passed unit test and integration testing...
# installs all the packages in the table with the appropriate method of installation
installPackages() {
# check if our aur helper is installed...
if [ $(pacman -Qqm | grep $aurHelper) == "$aurHelper" ]; then

	echo 'now we can start working on installing packages since yay is installed...'
else
	gitmakeinstall $aurHelperRepo || error "couldn't install aur helper..."
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
		gitmakeinstall $package

	fi

done < $programsTable



}

# passed unit testing only...
setUpConfigs(){
# add more config files to the system...
echo 'hello there2...'
	[ -z "$3" ] && branch="main" || branch="$dotRepoBranch"
	dir=$(mktemp -d)
	[ ! -d "$2" ] && mkdir -p "$2"
	chown "$userName":wheel "$dir" "$2"
	sudo -u "$userName" git clone --recursive -b "$branch" --depth 1 --recurse-submodules "$1" "$dir" #> /dev/null 2>&1
	sudo -u "$userName" cp -rfT "$dir" "$2"
}


# the following method only has integration testing cuz it has everything in it...
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
[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers

# make it into a function later for readability...
printf "%wheel ALL=(ALL) ALL\n%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/paru,/usr/bin/pacman -Syyuw --noconfirm" >> /etc/sudoers

# installation loop...


# change pacman and paru themes...
grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# use all the cores for compilation...
sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# starting installattion loop...
installPackages

# downloading ang setting up  the config files...
setUpConfigs $dotFilesRepo "/home/$userName" $dotRepoBranch

# delete extra files from the home (that came from the config being cloned in home) ...
# manually delete extra files and folders from the home of the user...
rm -rf /home/$username/.git /home/$username/LICENSE /home/$username/README.md




}



################# start of functional programming... #################
main
