# Begining of .bashrc custom config

warn() {
    YELLOW='\033[1;33m'
    NC='\033[0m'

    echo -e "${YELLOW}WARNING: $@${NC}"
}

# Beginning of gum config (see https://github.com/charmbracelet/gum)

# clear all previous configs
# unset "${!GUM_@}"

export BOLD=0

# write mode
export GUM_WRITE_BASE_BORDER="normal"
export GUM_WRITE_WIDTH="72" # commit message should have line <= 72 symbols
export GUM_WRITE_HEIGHT="10"
export GUM_WRITE_PROMPT=" "
export GUM_WRITE_BASE_BORDER_FOREGROUND="11"
export GUM_WRITE_CURSOR_LINE_BACKGROUND="8"
export GUM_WRITE_CURSOR_FOREGROUND="11"
export GUM_WRITE_BASE_ALIGN="center"

# input mode
export GUM_INPUT_PROMPT="┃ "
export GUM_INPUT_CURSOR_FOREGROUND="11"
export GUM_INPUT_WIDTH="50" # commit message should have <= 50 symbols
export GUM_WRITE_PROMPT_FOREGROUND="4"

# confirm mode
export GUM_CONFIRM_PROMPT_BORDER="rounded"
export GUM_CONFIRM_PROMPT_ALIGN="center"
export GUM_CONFIRM_PROMPT_WIDTH="50"
export GUM_CONFIRM_PROMPT_BORDER_FOREGROUND="11"
export GUM_CONFIRM_SELECTED_BACKGROUND="11"
export GUM_CONFIRM_SELECTED_FOREGROUND="16"
export GUM_CONFIRM_UNSELECTED_BACKGROUND=""
export GUM_CONFIRM_UNSELECTED_FOREGROUND="15"

# spin mode
export GUM_SPIN_TITLE=" "
export GUM_SPIN_SPINNER_FOREGROUND="11"
export GUM_SPIN_SHOW_OUTPUT="1"

# End of gum config

git-commit() {
    COMMIT_MESSAGE=$(gum write --char-limit=0 --placeholder "Commit message (CTRL+D to finish)")
    printf "$COMMIT_MESSAGE" >/tmp/.commit_msg.bak
    gum confirm "Commit changes?" && git commit -m "$COMMIT_MESSAGE"
}

git-log() {
	FMT_HASH='%C(bold magenta)%h%C(reset)'
	FMT_INFO='%C(cyan)<%ae> %ad%C(reset)'
	FMT_BRANCH='%C(bold yellow)%d%C(reset)'
	FMT_SUBJECT='%C(bold white)%s%C(reset)'
	FMT_BODY='%w(0,4,4)%b'
	git log --pretty=format:"$FMT_HASH $FMT_INFO $FMT_BRANCH%n%n    $FMT_SUBJECT%n%n$FMT_BODY" $@
}

#ping() {
#	warn "ping was replaced by gping command"
#	gping --clear $@
#}

note-add() {
	local BORDER_COLOR="12"
	local NOTE_PATH="$NOTE_PATH_GLOBAL"
	[[ "$1" != ""  ]] && NOTE_PATH="$1"

	if [[ "$NOTE_PATH" == ""  ]]; then
		warn "Note path not specified neither in variable NOTE_PATH_GLOBAL not in command line argument"
		return
	fi

	local NOTE_DATA=$(gum write --char-limit=0 \
	                  --placeholder "Note message (CTRL+D to finish)" \
		          --base.border-foreground="$BORDER_COLOR" \
		          --cursor.foreground="$BORDER_COLOR")


	printf "$NOTE_DATA" >/tmp/.note_data.bak


	gum confirm "Commit note?"  \
	            --selected.background="$BORDER_COLOR" \
	            --prompt.border-foreground="$BORDER_COLOR" && \
	{
		local ts="$(date '+%a %b %d %T %Y')"
		printf "\n**$ts**\n\n" >>$NOTE_PATH
		printf "$NOTE_DATA\n" >>$NOTE_PATH
		printf "\n---\n" >>$NOTE_PATH
	}
}

# End of .bashrc custom config
