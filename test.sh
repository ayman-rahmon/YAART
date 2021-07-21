if [ $(pacman -Qqm | grep yay-git) == "yay-git" ]; then

	echo installed

else
	echo "not installed..."
fi
