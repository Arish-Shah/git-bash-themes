reset="\001\033[0m\002"
bold="\001\033[1m\002"
red="\001\033[31m\002"
green="\001\033[32m\002"
yellow="\001\033[33m\002"
cyan="\001\033[36m\002"
white="\001\033[37m\002"

#background
blue_bg="\001\033[44m\002"
green_bg="\001\033[42m\002"

intro="Welcome to fish, the friendly interactive shell"
fish="⋊>"
insert_mode="$white$bold$green_bg[I]$reset "

function fish_prompt {
	if [ $? -eq 0 ]; then
		echo -e "$white$blue_bg$fish$reset"
	else
		echo -e "$bold$red$fish$reset"
	fi
}

if test -f ~/.config/git/git-prompt.sh
then
	. ~/.config/git/git-prompt.sh
else
	PS1='\001\033]0;Git Bash\007\002'         # set window title
	echo "$intro"                             # fish intro text
	PS1="$PS1""$insert_mode"                  # Insert Mode [I]
	PS1="$PS1""\$(fish_prompt)"               # prompt
	PS1="$PS1"" "
	PS1="$PS1$yellow""\w"                     # current directory
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
			PS1="$PS1""$reset"
			PS1="$PS1""\$(__git_ps1 ' on $green%s')"   # bash function
		fi
	fi
	PS1="$PS1""$reset "
fi

MSYS2_PS1="$PS1"                       # for detection by MSYS2 SDK's bash.basrc

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