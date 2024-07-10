# Begining of .bashrc custom config

# Dependencies:
# gum: https://github.com/charmbracelet/gum
# mdcat: https://github.com/swsnr/mdcat
# fzf: https://github.com/junegunn/fzf

warn() {
    YELLOW='\033[1;33m'
    NC='\033[0m'

    echo -e "${YELLOW}WARNING: $@${NC}"
}

# Beginning of gum config

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

	echo -ne "$NOTE_DATA" >/tmp/.note_data.bak


	gum confirm "Commit note?"  \
	            --selected.background="$BORDER_COLOR" \
	            --prompt.border-foreground="$BORDER_COLOR" && \
	{
		local ts="$(date '+%a %b %d %T %Y')"
		echo -ne "\n**$ts**\n\n" >>$NOTE_PATH
		echo -ne "$NOTE_DATA\n" >>$NOTE_PATH
		echo -ne "\n---\n" >>$NOTE_PATH
	}
}

_todolist_preview() {
	local NOTE_PATH="$1"

	printf "**TODO**\n\n"
	grep "TODO:" <$NOTE_PATH | awk '{print $0 "\n"}' | sed 's/^TODO:/- [ ] /g'
}

_note_preview() {
	local NOTE_PATH="$1"
	local title="**$2**"

	if [ "$title" = "**TODO**" ]; then
		_todolist_preview $NOTE_PATH
		return
	fi

	local found="0"

	while IFS= read -r line; do
		if [ "$line" = "$title" ]; then
			found="1"
		fi

		if [ "$found" = "1" ]; then
			if [ "$line" = "---" ]; then
				return
			fi

			echo "$line"
		fi
	done < $NOTE_PATH
}

markdown_note_preview() {
	# Fix render area for preview
	local current_cols=$(tput cols)
	local new_cols=$((current_cols / 2 - 5))

	local markdown="$(_note_preview $@)"

	# Do not display TODO lines
	markdown=$(grep -v "^TODO:" <<< "$markdown")

	mdcat --columns $new_cols <<< $markdown
}

note-read() {
	local NOTE_PATH="$NOTE_PATH_GLOBAL"
	[[ "$1" != ""  ]] && NOTE_PATH="$1"

	if [[ "$NOTE_PATH" == ""  ]]; then
		warn "Note path not specified neither in variable NOTE_PATH_GLOBAL not in command line argument"
		return
	fi

	local regex="(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9] [0-9]{4}"
	local notes=$(grep -E $regex $NOTE_PATH | tail -r | sed 's/**//g')

	# Do not display notes, which are empty
	# (including notes which contain only TODO lines, as TODO lines are not displayed)
	local nonempty_notes=""
	while IFS= read -r note; do
		if markdown_note_preview $NOTE_PATH $note | grep -v $note | grep -q '[^[:space:]]'; then
			nonempty_notes+="$note"$'\n'
		fi
	done <<< "$notes"
	notes=$(grep  '[^[:space:]]' <<<"$nonempty_notes")

	# Add TODO section if it exists
	grep -q TODO < "$NOTE_PATH" &&  notes="$(echo TODO; echo $notes)"

	fzf --preview="$(export -f _todolist_preview _note_preview markdown_note_preview); markdown_note_preview $NOTE_PATH {}" <<< "$notes"
}

# End of .bashrc custom config
