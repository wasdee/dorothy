#!/bin/bash

# don't use contains command, as it won't detect things like
# PATH=a/b
# add PATH a

function clear {
	export "$1"=''
}
function append {
	export "$1"="$2:${!1}"
}
function prepend {
	export "$1"="${!1}:$2"
}

# Add local npm executables
prepend PATH "./node_modules/.bin"

# User
if is_dir "$HOME/bin"; then
	append PATH "$HOME/bin"
fi

# Homebrew
if is_dir "$HOME/bin"; then
	append PATH "$HOME/bin"
fi

# Homebrew
if command_exists brew; then
	export BREW_PREFIX; BREW_PREFIX=$(brew --prefix)
	append PATH "$BREW_PREFIX/bin"
	append MANPATH "$BREW_PREFIX/man"

	# Heroku
	if is_dir "$BREW_PREFIX/bin"; then
		append PATH "$BREW_PREFIX/heroku/bin"
	fi

	# Ruby
	if is_dir "$BREW_PREFIX/opt/ruby/bin"; then
		append PATH "$BREW_PREFIX/opt/ruby/bin"
	fi
fi

# Go
if command_exists go; then
	if is_empty_string "$GOPATH"; then
		export GOPATH=$HOME/.go
		mkdir -p "$GOPATH"
	fi
	append PATH "$GOPATH/bin"
fi

# Ruby
if command_exists ruby; then
	if is_empty_string "$GEM_HOME"; then
		export GEM_HOME=$HOME/.cache/gems
		mkdir -p "$GEM_HOME"
	fi
	append PATH "$GEM_HOME/bin"
fi

# Java
if is_empty_string "$CLASSPATH"; then
	append CLASSPATH "."
fi

# Clojurescript
if is_dir "$HOME/.clojure/clojure-1.8"; then
	append PATH "$HOME/.clojure/clojure-1.8.0"
	append CLASSPATH "$HOME/.clojure/clojure-1.8.0"
fi

# Yarn
if command_exists yarn; then
	append PATH "$(yarn global bin)"
fi

# Finish
export PATHS_SET=true
