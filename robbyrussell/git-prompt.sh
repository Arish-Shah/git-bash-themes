reset="\001\033[0m\002"
red="\001\033[31m\002"
green="\001\033[32m\002"
yellow="\001\033[33m\002"
blue="\001\033[34m\002"
magenta="\001\033[35m\002"
cyan="\001\033[36m\002"
white="\001\033[37m\002"

function parse_git_dirty {
	[[ $(git status --porcelain 2> /dev/null | tail -n1) != "" ]] && echo -e "$yellow ✗"
}

function arrow_color {
	if [ $? -eq 0 ]; then
		echo -e "$green➜"
	else
		echo -e "$red➜"
	fi
}

if test -f ~/.config/git/git-prompt.sh
then
	. ~/.config/git/git-prompt.sh
else
	PS1='\001\033]0;Git-Bash\007\002'  # set window title
	PS1="$PS1""\$(arrow_color) "   # change arrow color if command fails
	PS1="$PS1""$cyan"              # change to cyan
	PS1="$PS1"' \W'                # <space> current working directory
	if test -z "$WINELOADERNOEXEC"
	then
		GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
		COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
		COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
		COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
		if test -f "$COMPLETION_PATH/git-prompt.sh"
		then
			. "$COMPLETION_PATH/git-completion.bash"
			. "$COMPLETION_PATH/git-prompt.sh"
			PS1="$PS1""$blue"                                # change color to blue
			PS1="$PS1""\$(__git_ps1 ' git:($red%s$blue)')"   # bash function
			PS1="$PS1""\$(parse_git_dirty)"                  # shows ✗ if dirty
		fi
	fi
	PS1="$PS1"'\001\033[0m\002 '         # reset color
fi

MSYS2_PS1="$PS1"               # for detection by MSYS2 SDK's bash.basrc

# Evaluate all user-specific Bash completion scripts (if any)
if test -z "$WINELOADERNOEXEC"
then
	for c in "$HOME"/bash_completion.d/*.bash
	do
		# Handle absence of any scripts (or the folder) gracefully
		test ! -f "$c" ||
		. "$c"
	done
fi