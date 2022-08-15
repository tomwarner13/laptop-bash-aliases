# emoji prompt
export PS1='🏠\[\033[38;5;214m\]\u\[$(tput sgr0)\]@\[\033[38;5;39m\]\h\[$(tput sgr0)\][\[\033[38;5;11m\]\W\[$(tput sgr0)\]]\[\033[36m\]`__git_ps1` \[$(tput sgr0)\]| \[\033[38;5;213m\]\t\[$(tput sgr0)\] 🏠\$ '

# necessary for something lol idk, probably some weird dependency
export PATH=$PATH:/c/Users/twarner/AppData/Roaming/Python/Python310/Scripts/

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
		"NVMPIAH")
			TARGET="new-importer/"
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

# usage: review <ticket>

review() {
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

	rawRemote=`echo "$remote" | sed -E 's/.*origin\/(.*)/\1/'`
	git checkout $rawRemote
	git pull
	gsm
}