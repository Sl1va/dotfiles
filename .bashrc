# Begining of .bashrc custom config

# Beginning of gum config (see https://github.com/charmbracelet/gum)

# clear all previous configs
unset "${!GUM_@}"

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

git-commit() {
    COMMIT_MESSAGE=$(gum write --placeholder "Commit message (CTRL+D to finish)")
    gum confirm "Commit changes?" && git commit -m "$COMMIT_MESSAGE"
}

# End of gum config

# End of .bashrc custom config
