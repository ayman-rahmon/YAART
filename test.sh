aurInstall() {
	# consider keeping the source somewhere in the system later (for suckless programs)...
	repoName=$(basename $1 .git)
	(git clone $1 && cd $repoName && makepkg -si)
	rm -rf $repoName
}



aurInstall https://github.com/cjbassi/gotop.git
