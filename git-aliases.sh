# HEY DINGUS--IF YOU ARE LOOKING FOR A CUSTOM GIT COMMAND YOU WROTE AND IT'S NOT IN HERE, IT'S CAUSE YOU WROTE IT AS A GIT ALIAS INSTEAD -- CHECK `git config -e --global`

gacp() {
	git add . && git commit -m "$1" && git pushup
}


gcp() {
	git commit -m "$1" && git pushup
}

alias gp='git pushup'

gfl() {
	if [ $# -eq 0 ]; then
		git pull
	else
		git fetch && git checkout "$1" && git pull
	fi
}

alias grhh='git reset --hard HEAD'
alias gsm='git submodule update --init --recursive'
alias gs='git status'
alias gd='git diff'

gcb() {
	git checkout -b "$1"
}

gst() {
		git clean -fd
		git reset --hard HEAD
		git checkout master
		git pull
		git submodule update --init --recursive
		git checkout -b "$1"
}

#git-branch-tag
gbt() {
	git checkout tags/$1 -b $2
}

#git-pull-down -- a git pull, but the way it should fucking work all the time
gpd() {
	head="$(git rev-parse --abbrev-ref HEAD)"

	if [[ $(git config "branch.$head.merge") ]]; then #there's already a merge target configured, just pull as normal from there
		git pull
	else
		if [[ $(git ls-remote --heads origin $head) ]]; then #there is an upstream branch existing with the same name as our branch
			git branch --set-upstream-to origin/$head #set merge target to upstream branch with same name
			git pull
		else #fail with explanation
			echo "Branch $head has no upstream or merge target! You will likely have to push first, or manually configure it"
			return 1
		fi
	fi
}