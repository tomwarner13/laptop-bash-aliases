# emoji prompt
export PS1='🏠\[\033[38;5;214m\]\u\[$(tput sgr0)\]@\[\033[38;5;39m\]\h\[$(tput sgr0)\][\[\033[38;5;11m\]\W\[$(tput sgr0)\]]\[\033[36m\]`__git_ps1` \[$(tput sgr0)\]| \[\033[38;5;213m\]\t\[$(tput sgr0)\] 🏠\$ '

# various dependencies necessary for path
export PATH=$PATH:/c/Users/twarner/AppData/Roaming/Python/Python310/Scripts/:/c/bin/:/c/Program\ Files/Sublime\ Merge:/c/Program\ Files/JetBrains/JetBrains\ Rider\ 2023.1.3/bin/

# this somehow points to the wrong path to build stuff for Snipster by default
JAVA_HOME='C:\Program Files\Java\jdk-18.0.2.1'

# saves some typing lol
alias snipster-go='./gradlew build && ./gradlew stage && heroku local -f Procfile.windows'

alias lg='winpty lazygit && tput cnorm'
alias azl='az login'

vs() {
	current_path="$(pwd)"
	#start SITESAA with the correct solution file cause there's (sigh) three
	if [ "$current_path" = "/c/DealerOn/Platform" ]; then
		pwsh -command 'Start-Process devenv Source\SITESAA.sln'
	else
		pwsh -command 'Start-Process devenv $(find . -maxdepth 2 -name *.sln)'
	fi
	#start Torque apps in 2019 because the stupid breakpoint bug
#	if [ "$current_path" = "/c/DealerOn/Pricing" ] || [ "$current_path" = "/c/DealerOn/Inventory" ]; then
#		pwsh -command 'Start-Process "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe" $(find . -maxdepth 2 -name *.sln)'
#	else
#		pwsh -command 'Start-Process devenv $(find . -maxdepth 2 -name *.sln)'
#	fi
}

ride() {
	# rider path if necessary: C:\Program Files\JetBrains\JetBrains Rider 2023.1.3\bin\rider64.exe
	current_path="$(pwd)"
	#start SITESAA with the correct solution file cause there's (sigh) three
	if [ "$current_path" = "/c/DealerOn/Platform" ]; then
		pwsh -command 'Start-Process rider64 Source\SITESAA.sln'
	else
		pwsh -command 'Start-Process rider64 $(find . -maxdepth 2 -name *.sln)'
	fi
	shuf -n 1 ~/bash-aliases/mc_ride.txt
}

alias reamde='ls | grep -i "readme.md" | xargs head -20'

#cc <project> -- opens the repo associated with a project code
cc() {
	if [ $# -eq 0 ]
	then
		cd /c/DealerOn
		return 0
	fi

	TARGET=""
	case "${1^^}" in
		"LCMSSAB")
			TARGET="CMS/"
			;;
		"LCMSBAA")
			TARGET="Dash/"
			;;
		"NVMPIAA")
			TARGET="DataDownloader/"
			;;
		"EXPTIAA")
			TARGET="Exports/"
			;;
		"NVMPIAB")
			TARGET="FileConverter/"
			;;
		"IGNISAA")
			TARGET="Ignition/"
			;;
		"NVMPBAA")
			TARGET="Inventory/"
			;;
		"SITESAA")
			TARGET="Platform/"
			;;
		"LCMSSAA")
			TARGET="Powertrain/"
			;;
		"PRLGBAA")
			TARGET="Pricing/"
			;;
		"NVMPIAD")
			TARGET="Refresher/"
			;;
		"NVMPIAE")
			TARGET="TorqueMonitor/"
			;;
		"FRAUUTA")
			TARGET="Utilities/"
			;;
		"PRLGSHA")
			TARGET="do.dealerpricing/"
			;;
		"NVMPSAA")
			TARGET="do.inv.api/"
			;;
		"EXPTSAA")
			TARGET="do.inv.exportsapi/"
			;;
		"EXPTBAA")
			TARGET="do.inv.exportsconfig/"
			;;
		"NVMPIAG")
			TARGET="do.inv.indexer/"
			;;
		"PRCEBAA")
			TARGET="do.inv.pricing/"
			;;
		"PRCESHA")
			TARGET="do.inv.pricing.engine/"
			;;
		"PRCEIAA")
			TARGET="do.inv.pricing.htmlgen/"
			;;
		"PRCEIAB")
			TARGET="do.inv.pricing.pricegen/"
			;;
		"NVMPIAC")
			TARGET="torqueftplistener/"
			;;
		"NVMPIAF")
			TARGET="tractioncontrol/"
			;;			
		"CODETESTS")
			TARGET="CodeTests/"
			;;			
		"SNIPSTER")
			TARGET="Snipster/"
			;;			
		"NVMPIAH")
			TARGET="new-importer/"
			;;
		"STRGSHA")
			TARGET="strgsha/"
			;;
		"INVTOTA")
			TARGET="invtota/"
			;;
		"INVTSHA")
			echo "Data or schema?"
			select choice in "Data" "Schema"; do
				case $choice in
					Data ) TARGET="DB-Changes/"; break;;
					Schema ) TARGET="do.shared.ssdt.inventory/"; break;;
				esac
			done
			;;
		*)
			TARGET="$1/"
			;;

	esac
	cd /c/DealerOn/$TARGET
}

# usage: reviewjs <ticket>

reviewjs() {
	ticket=${1^^}
	# extract project abbrev, cc to that repo
	project=`echo "$ticket" | sed -E 's/([A-Z]{7}).*/\1/'`
	cc $project

	# fail if uncommited changes
	if [[ ! -z $(git status --porcelain) ]]; then
		echo "the repo is in an unclean state! any degeneracy must be purged"
		return 1
	fi

	# fetch all branches; pull latest on any that matches the ticket number if available
	git fetch
	remote=`git branch -r | grep $ticket`
	#fail on empty remote
	if [[ -z $remote ]]; then
		echo "no remote branch matching the ticket number $ticket could be found!"
		return 1
	fi

	# more than one branch matched, prompt user to choose or exit
	if [[ $(echo "$remote" | wc -l) -ne 1 ]]; then
		echo "multiple branches matched the given ticket, choose by number or [0] to exit"
		readarray -t remotes <<<"$remote"
		select branch in "${remotes[@]}"; do
			if [[ -z "$branch" ]]; then
		        echo "Exiting..."
		        return 1
		    fi
			remote=$branch
			break;
		done
	fi

	rawRemote=`echo "$remote" | sed -E 's/.*origin\/(.*)/\1/'`
	git checkout $rawRemote
	git pull
	gsm
}

# updated for jira cloud
# usage: review nvmpbaa oem-5576

review() {
	ticket=${2^^}
	project=${1^^}
	cc $project

	# fail if uncommited changes
	if [[ ! -z $(git status --porcelain) ]]; then
		echo "the repo is in an unclean state! any degeneracy must be purged"
		return 1
	fi

	# fetch all branches; pull latest on any that matches the ticket number if available
	git fetch
	remote=`git branch -r | grep $ticket`
	#fail on empty remote
	if [[ -z $remote ]]; then
		echo "no remote branch matching the ticket number $ticket could be found!"
		return 1
	fi

	# more than one branch matched, prompt user to choose or exit
	if [[ $(echo "$remote" | wc -l) -ne 1 ]]; then
		echo "multiple branches matched the given ticket, choose by number or [0] to exit"
		readarray -t remotes <<<"$remote"
		select branch in "${remotes[@]}"; do
			if [[ -z "$branch" ]]; then
		        echo "Exiting..."
		        return 1
		    fi
			remote=$branch
			break;
		done
	fi

	rawRemote=`echo "$remote" | sed -E 's/.*origin\/(.*)/\1/'`
	git checkout $rawRemote
	git pull
	gsm
}

reviews() {
	review SITESAA $1
}

rc() {
	if [ $# -eq 1 ]
	then
		RC="$1"
	fi

	echo $RC
}

alias sauce="source ~/.bashrc"

# env vars for jirae, https://github.com/codesoap/jirae
export EDITOR=vim
export JIRA_URL=https://dealeron.atlassian.net
export JIRA_USER=twarner@dealeron.com
# TOKEN LIVES IN .bashrc SO IT CANT GET PUSHED REMOTELY