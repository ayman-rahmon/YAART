#bin/bash
# this script is written by Ayman Rahmon and it was designed to be run from the root user of a fresh installed arch linux system...

# adding a new user and setting it up
read username
read password
###### test this code ##################################
useradd --create-home $username
passwd ${username} << EOD
${password}
${new_ps}
${new_ps}
EOD





# update all the databases and the system...
pacman -Syu

# reading from a csv file and actually installing packages...
filename="programs.csv"
sed 1d $filename | while IFS=, read  source package description
do
	echo "$source \t $package \t $description"


	if [ $source == 'pacman' ] ; then
		pacman -S $package

	elif [ $source == 'aur' ] ; then
		yay  -S $package
	elif [ $source == 'Git' ] ; then
		repoName= basename $package | sed 's/.\{4\}$//'
		(git clone $package && cd repoName && makepkg -si)
		rm -rf repoName

	fi

done < $filename
# setting up ~/.xinitrc in the user's home...




# setting up zsh as the default shell for the user...


# oh my zsh installation...



# clonning and copying all of the config files to their correct location for the user...
