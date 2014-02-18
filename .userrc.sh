###
# Configuration

###
# Environemnt

# Shell
if test -n "$ZSH_VERSION"; then
	export PROFILE_SHELL='zsh'
	local HOSTNAME='%m'
elif test -n "$BASH_VERSION"; then
	export PROFILE_SHELL='bash'
elif test -n "$KSH_VERSION"; then
	export PROFILE_SHELL='ksh'
elif test -n "$FCEDIT"; then
	export PROFILE_SHELL='ksh'
elif test -n "$PS3"; then
	export PROFILE_SHELL='unknown'
else
	export PROFILE_SHELL='sh'
fi

# Bash
if [[ $PROFILE_SHELL = "bash" ]]; then
	# Standard
	export RED="\[\033[0;31m\]"
	export RED_BOLD="\[\033[01;31m\]"
	export BLUE="\[\033[0;34m\]"
	export CYAN='\[\e[0;36m\]'
	export PURPLE='\[\e[0;35m\]'
	export GREEN="\[\033[0;32m\]"
	export YELLOW="\[\033[0;33m\]"
	export BLACK="\[\033[0;38m\]"
	export NO_COLOUR="\[\033[0m\]"

	# Custom
	export C_RESET='\[\e[0m\]'
	export C_TIME=$GREEN
	export C_USER=$BLUE
	export C_PATH=$YELLOW
	export C_GIT_CLEAN=$CYAN
	export C_GIT_DIRTY=$RED

elif [[ $PROFILE_SHELL = "zsh" ]]; then
	# Custom
	export C_RESET=$reset_color
	export C_TIME=$fg[green]
	export C_USER=$fg[blue]
	export C_PATH=$fg[yellow]
	export C_GIT_CLEAN=$fg[cyan]
	export C_GIT_DIRTY=$fg[red]
fi

# Don't check mail
export MAILCHECK=0

# Apps
mkdir -p ~/bin

# Custom
if [[ -s ~/.customrc ]]; then
	source ~/.customrc
fi

# RBEnv
if which rbenv > /dev/null; then
	eval "$(rbenv init -)"
fi

# NVM
if [[ -s ~/.nvm/nvm.sh ]]; then
	NVM_DIR=~/.nvm
	source ~/.nvm/nvm.sh
fi

# Hub
#if which hub > /dev/null; then
#	alias git='hub'
#fi

# Sublime
if [ ! -f ~/bin/sublime ]; then
	if [ -f "/opt/sublime_text_2/sublime_text" ]; then
		ln -s "/opt/sublime_text_2/sublime_text" ~/bin/subl
	fi
fi

# Theme
source "$HOME/.usertheme.sh"


###
# Functions

# Airmail
export airmailPrefDirUser="$HOME/Library/Containers/it.bloop.airmail.beta8/Data/Library/Application Support/Airmail/General"
export airmailPrefDirSync="$HOME/Dropbox/Preferences/Airmail"
function airmail_to_sync {
	mkdir -p "$airmailPrefDirSync"
	rm "$airmailPrefDirSync/prefs"
	rm "$airmailPrefDirSync/Accounts.db"
	cp "$airmailPrefDirUser/prefs" "$airmailPrefDirSync/prefs"
	cp "$airmailPrefDirUser/Accounts.db" "$airmailPrefDirSync/Accounts.db"
}
function sync_to_airmail {
	mkdir -p "$airmailPrefDirUser"
	rm "$airmailPrefDirUser/prefs"
	rm "$airmailPrefDirUser/Accounts.db"
	cp "$airmailPrefDirSync/prefs" "$airmailPrefDirUser/prefs"
	cp "$airmailPrefDirSync/Accounts.db" "$airmailPrefDirUser/Accounts.db"
}

# DocPad Extra Branch Sync
function docpad_branch_sync {
	git checkout docpad-6.x
	git pull origin docpad-6.x
	git merge master

	git checkout master
	git pull origin master
	git merge docpad-6.x

	git checkout docpad-6.x
	git merge master

	git checkout dev
	git pull origin dev
	git merge master

	git checkout master
	git push origin --all
}


###
# Aliases

# Aliases: System
alias reload='source ~/.userrc.sh'
alias bye='exit'
alias restartaudio="sudo kill `ps -ax | grep 'coreaudiod' | grep 'sbin' |awk '{print $1}'`"

# Aliases: Compliance
alias php5='php'
alias make="make OS=$OS OSTYPE=$OSTYPE"

# Aliases: Node
if [[ -f `which nvm` ]]; then
	alias nta4='nvm use 0.4 && npm test && nvm use 0.6 && npm test && nvm use 0.8 && npm test'
	alias nta6='nvm use 0.6 && npm test && nvm use 0.8 && npm test'
fi
alias npmusa='npm set registry http://registry.npmjs.org/'
alias npmaus='npm set registry http://registry.npmjs.org.au/'
alias npmpublish='npmusa; npm publish; npmaus'
alias cakepublish='npmusa; cake publish; npmaus'

# Aliases: App Fog
if [[ -f `which af` ]]; then
	alias afs='af logs $1; af crashes $1; af files $1'
	alias afd='af delete $1; af push $1; af start $1'
	alias afu='af update $1; af start $1'
	afpush() { af update $@; aflog $@; }
	aflog() { af logs $@; af crashlogs $@; af instances $@; }
fi

# Aliases: Minify
# minify() {
#	rm -f $@.min.js $@.min.map;
#	uglifyjs $@.js -o $@.min.js --source-map $@.min.map;
# }

# Aliases: Git
alias ga='git add'
alias gu='git add -u'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'
alias gitclean='rm -rf .git/refs/original/; git reflog expire --expire=now --all; git gc --prune=now; git gc --aggressive --prune=now'
alias gitsvnupdate='git-svn rebase'
alias gpo='gp origin; gp origin --tags'
alias gitrm='git ls-files --deleted | xargs git rm'
alias git-svn='git svn'
alias gitsync='git checkout dev && git merge master; git checkout master && git merge dev; git checkout dev; git push origin --all && git push origin --tags'
alias release='npm publish && git tag -a $1'

# Aliases: System
alias editprofile='edit ~/.profile ~/.*profile ~/.*rc'
alias edithooks='edit .git/hooks/pre-commit'
alias edithosts='sudo sublime /etc/hosts'

# Aliases: Tar
alias mktar='tar -cvzf'
alias extar='tar -xvzf'

# Aliases: Administration
alias sha1check='openssl sha1 '
alias takeownership='sudo chown -R balupton .'
alias svnshowexternals='svn propget -R svn:externals .'
alias rmsvn='sudo find . -name ".svn" -exec rm -Rf $1 {} \;'
alias rmtmp='sudo find ./* -name ".tmp*" -exec rm -Rf $1 {} \;'
alias flushdns='dscacheutil -flushcache'
alias rmall='rm -fdR'
alias search='find . -name'
alias allow='chmod +x'

# Aliases: Rails
alias dierails='ps -a|grep "/usr/local/bin/ruby script/server"|grep -v "grep /usr"|cut -d " " -f1|xargs -n 1 kill -KILL $1'
alias resetrails='ps -a|grep "/usr/local/bin/ruby script/server"|grep -v "grep /usr"|cut -d " " -f1|xargs -n 1 kill -HUP $1'

# Alises: Zend
if [[ -f `which zendctl.sh` ]]; then
	alias restartzend='sudo zendctl.sh restart'
	alias startzend='sudo zendctl.sh start'
	alias startzendx='startzend; mysqld'
	alias stopzend='sudo zendctl.sh stop'
	alias cleanzend='sudo rm -Rf /usr/local/zend /etc/my.cnf /tmp/mysql.sock'
	alias postinstallzend='sudo rm -f /tmp/mysql.sock /etc/my.cnf ; sudo ln -s /usr/local/zend/mysql/tmp/mysql.sock /tmp/mysql.sock ; sudo ln -s /usr/local/zend/mysql/data/my.cnf /etc/my.cnf'
	alias mysql='/usr/local/zend/mysql/bin/mysql'
	alias mysqladmin='/usr/local/zend/mysql/bin/mysqladmin'
	alias editmysql='edit /usr/local/zend/mysql/support-files/my.cnf'
	alias openmysql='open /usr/local/zend/mysql/'
	alias openserver='open /usr/local/zend/mysql/'
fi

# Aliases: Copy
if [[ -f `which xclip` ]]; then
	alias copy='pbcopy '
elif [[ -f `which pbcopy` ]]; then
	alias copy='pbcopy '
fi

# Aliases: Edit
if [[ -f `which subl` ]]; then
	alias edit='subl'
elif [[ -f `which gedit` ]]; then
	alias edit='gedit'
fi

# Aliases: OSX
if [[ "$OS" = "Darwin" ]]; then
	# System
	alias stackhighlightyes='defaults write com.apple.dock mouse-over-hilte-stack -boolean yes ; killall Dock'
	alias stackhighlightno='defaults write com.apple.dock mouse-over-hilte-stack -boolean no ; killall Dock'
	alias showallfilesyes='defaults write com.apple.finder AppleShowAllFiles TRUE ; killall Finder'
	alias showallfilesno='defaults write com.apple.finder AppleShowAllFiles FALSE ; killall Finder'
	alias autoswooshyes='defaults write com.apple.Dock workspaces-auto-swoosh -bool YES ; killall Dock'
	alias autoswooshno='defaults write com.apple.Dock workspaces-auto-swoosh -bool NO ; killall Dock'
	alias nodesktopicons='defaults write com.apple.finder CreateDesktop -bool false'

	# MD5
	alias md5sum='md5 -r'

	# Applications
	alias iosdev='open /Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app'
	alias androiddev='/Applications/Android\ Studio.app/sdk/tools/emulator -avd basic'
	alias installapp='brew cask install'
fi

# Aliases: Linux
if [[ "$OS" = "Linux" ]]; then
	alias resetfirefox="rm ~/.mozilla/firefox/*.default/.parentlock"
fi

# Aliases: Wget
alias wgett='echo -e "\nHave you remembered to correct the following:\n user agent, trial attempts, timeout, retry and wait times?\n\nIf you are about to leech use:\n [wgetbot] to brute-leech as googlebot\n [wgetff]  to slow-leech  as firefox (120 seconds)\nRemember to use -w to customize wait time.\n\nPress any key to continue...\n" ; read -n 1 ; wget --no-check-certificate'
alias wgetbot='wget -t 2 -T 15 --waitretry 10 -nc --user-agent="Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"'
alias wgetff='wget -t 2 -T 15 --waitretry 10 -nc -w 120 --user-agent="-user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6""'
