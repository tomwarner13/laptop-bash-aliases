# emoji prompt
export PS1='🏠\[\033[38;5;214m\]\u\[\033[0m\]@\[\033[38;5;39m\]\h\[\033[0m\][\[\033[38;5;11m\]\W\[\033[0m\]]\[\033[36m\]`__git_ps1` \[\033[0m\]| \[\033[38;5;213m\]\t\[\033[0m\] 🏠\n\$ '

# various dependencies necessary for path
export PATH=$PATH:/usr/bin:/c/Users/twarner/AppData/Roaming/Python/Python310/Scripts/:/c/bin/:/c/Program\ Files/Sublime\ Merge:/c/Program\ Files/JetBrains/JetBrains\ Rider\ 2023.1.3/bin/:/c/Program\ Files/KDiff3/

#de-dupe PATH all at once instead of trying to do anything clever
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

# get RG to look in its config file (so it gets the right flag for path separator)
export RIPGREP_CONFIG_PATH='/c/Users/twarner/bash-aliases/.ripgreprc'

# make ls look nice
alias ls="ls -Fal --color"

# this somehow points to the wrong path to build stuff for Snipster by default
JAVA_HOME='C:\Program Files\Java\jdk-18.0.2.1'

# saves some typing lol
alias snipster-go='./gradlew build && ./gradlew stage && heroku local -f Procfile.windows'

alias lg='winpty lazygit && tput cnorm'
alias azl='az login'
alias ybs='(cd /c/DealerOn/Platform/Source/SITESAA.Presentation.Assets/ && yarn build)'
alias what="type" #just cause i always forget "type"

# build and run SITESAA from CLI
alias siterun='dotnet run --no-build --project /c/DealerOn/Platform/Source/SITESAA.Presentation.Site/SITESAA.Presentation.Site.csproj'
alias sitebuild='dotnet build /c/DealerOn/Platform/Source/SITESAA.sln'
alias sitebr='dotnet run --project /c/DealerOn/Platform/Source/SITESAA.Presentation.Site/SITESAA.Presentation.Site.csproj'

# build and run OEMSSAA from CLI
alias oemsrun='dotnet run --no-build --project /c/DealerOn/OEMSSAA/source/OEMSSAA.Presentation.Web/OEMSSAA.Presentation.Web.csproj'
alias oemsbuild='dotnet build /c/DealerOn/OEMSSAA/source/OEMSSAA.sln'
alias oemsbr='dotnet run --project /c/DealerOn/OEMSSAA/source/OEMSSAA.Presentation.Web/OEMSSAA.Presentation.Web.csproj'

# build and run FIRESAA from CLI
alias firerun='dotnet run --no-build --project /c/DealerOn/firesaa/source/FIRESAA.Presentation.Web/FIRESAA.Presentation.Web.csproj'
alias firebuild='dotnet build /c/DealerOn/firesaa/source/FIRESAA.sln'
alias firebr='dotnet run --project /c/DealerOn/firesaa/source/FIRESAA.Presentation.Web/FIRESAA.Presentation.Web.csproj'

# build and run REVWSAA from CLI
alias revwrun='dotnet run --no-build --project /c/DealerOn/REVWSAA/source/REVWSAA.Presentation.Web/REVWSAA.Presentation.Web.csproj'
alias revwbuild='dotnet build /c/DealerOn/REVWSAA/source/REVWSAA.sln'
alias revwbr='dotnet run --project /c/DealerOn/REVWSAA/source/REVWSAA.Presentation.Web/REVWSAA.Presentation.Web.csproj'

# set nvim to run in correct environment
# alias nvim="winpty nvim"
# alias python3="winpty python3"

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
	current_path="$(pwd)"
	#start SITESAA with the correct solution file cause there's (sigh) three
	if [ "$current_path" = "/c/DealerOn/Platform" ]; then
		pwsh -command 'Start-Process "C:\Program Files\JetBrains\JetBrains Rider 2023.3.2\bin\rider64.exe" Source\SITESAA.sln'
	else
		pwsh -command 'Start-Process "C:\Program Files\JetBrains\JetBrains Rider 2023.3.2\bin\rider64.exe" $(find . -maxdepth 2 -name *.sln)'
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

makepr() {
	branch=`git rev-parse --abbrev-ref HEAD`
	prOutput=$(az repos pr create --auto-complete=false -s $branch --title $branch)

	if [ $? -eq 0 ]; then
        webUrl=$(grep webUrl <<< $prOutput | sed -rn 's/^.*"webUrl": "([^"]+).*/\1/p')
        codeReviewId=$(grep codeReviewId <<< $prOutput | sed -rn 's/^.*"codeReviewId": ([^,]+).*/\1/p')
        prLink="${webUrl}/pullRequest/${codeReviewId}?_a=files"

        echo "Created PR: ${prLink}"
    else
        echo "Failed to create PR! Detailed output was:"
        echo "${prOutput}"
    fi
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

rcup () {
  git fetch
  autorc=$( git tag | grep "RC_.*\+SITESAA" | sort | tail -1 )
  rc $autorc
}

rc() {
	if [ $# -eq 1 ]
	then
		echo $1 > /c/Dealeron/.rc
	fi

	RC=$( cat /c/DealerOn/.rc )
	echo $RC
	echo ":sparkles: Latest RC: $RC"
}

printrc() {
	cat /c/DealerOn/.rc
}

alias sauce="source ~/.bashrc && rm ~/.githooks/prepare-commit-msg && ln -s ~/bash-aliases/prepare-commit-msg ~/.githooks/prepare-commit-msg"

hkdiff() {
	file1="$(mktemp)"
	file2="$(mktemp)"

	if [ $# -eq 3 ]
	then
		curl -k -H "X-Dealer-Id: $3" $1 -o $file1
		curl -k -H "X-Dealer-Id: $3" $2 -o $file2
	else
		curl -k $1 -o $file1
		curl -k $2 -o $file2
	fi

	kdiff3 $file1 $file2

	rm $file1
	rm $file2
}

# USAGE: oemsdiff just-drive-subaru-rental loadOemssaaSubaru 17777
# so oemsdiff <page> <toggle> <dealerId>

oemsdiff() {
	hkdiff https://localhost:7224/$1?$2=on https://localhost:7224/$1?$2=off $3
}

# env vars for jirae, https://github.com/codesoap/jirae
export EDITOR=vim
export JIRA_URL=https://dealeron.atlassian.net
export JIRA_USER=twarner@dealeron.com
# TOKEN LIVES IN .bashrc SO IT CANT GET PUSHED REMOTELY
