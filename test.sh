dotFilesRepo=https://github.com/ayman-rahmon/MyConfig.git
dotRepo="main"

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
	chown "$username":wheel "$dir" "$2"
	sudo -u "$username" git clone --recursive -b "$branch" --depth 1 --recurse-submodules "$1" "$dir" >/dev/null 2>&1
	sudo -u "$username" cp -rfT "$dir" "$2"
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
putgitrepo $dotFilesRepo "/home/tatsujin/temp" "$dotRepo"
