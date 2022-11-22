# emoji prompt
export PS1='🏠\[\033[38;5;214m\]\u\[$(tput sgr0)\]@\[\033[38;5;39m\]\h\[$(tput sgr0)\][\[\033[38;5;11m\]\W\[$(tput sgr0)\]]\[\033[36m\]`__git_ps1` \[$(tput sgr0)\]| \[\033[38;5;213m\]\t\[$(tput sgr0)\] 🏠\$ '

# necessary for something lol idk, probably some weird dependency
export PATH=$PATH:/c/Users/twarner/AppData/Roaming/Python/Python310/Scripts/

# this somehow points to the wrong path to build stuff for Snipster by default
JAVA_HOME='C:\Program Files\Java\jdk-18.0.2.1'

# saves some typing lol
alias snipster-go='./gradlew build && ./gradlew stage && heroku local -f Procfile.windows'

vs() {
#	current_path="$(pwd)"

	pwsh -command 'Start-Process devenv $(find . -maxdepth 2 -name *.sln)'
	#start Torque apps in 2019 because the stupid breakpoint bug
#	if [ "$current_path" = "/c/DealerOn/Pricing" ] || [ "$current_path" = "/c/DealerOn/Inventory" ]; then
#		pwsh -command 'Start-Process "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe" $(find . -maxdepth 2 -name *.sln)'
#	else
#		pwsh -command 'Start-Process devenv $(find . -maxdepth 2 -name *.sln)'
#	fi
}

alias reamde='ls | grep -i "readme.md" | xargs head -20'

#cc <project> -- opens the repo associated with a project code
cc() {
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
# usage: reviewc nvmpbaa oem-5576

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