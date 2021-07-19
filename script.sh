


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
		echo "Git one"
	fi

done < $filename
