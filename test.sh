dotFilesRepo=https://github.com/ayman-rahmon/MyConfig.git


setUpConfigs(){
repoName=$(basename $dotFilesRepo .git)
git clone $dotFilesRepo
mv $repoName/config /home/tatsujin/projects/bash/.config

}


setUpConfigs
