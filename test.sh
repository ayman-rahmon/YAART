dotFilesRepo=https://github.com/ayman-rahmon/MyConfig.git


setUpConfigs(){
repoName=$(basename $dotFilesRepo .git)
git clone $dotFilesRepo
mv $repoName/config /home/tatsujin/projects/bash/.config

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


gitInstall https://aur.archlinux.org/paru.git
