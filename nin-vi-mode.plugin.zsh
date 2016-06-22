# no delays for mode switching.
export KEYTIMEOUT=1

# for the iTerm2 terminal
function zle-keymap-select() {
  if [[ -n ${TMUX+x} ]]; then
    if [[ $KEYMAP = vicmd ]]; then
      # the command mode for vi: block shape
      echo -ne "\ePtmux;\e\e]1337;CursorShape=0\x7\e\\"
    else
      # the insert mode for vi: line shape
      echo -ne "\ePtmux;\e\e]1337;CursorShape=1\x7\e\\"
    fi
  elif [[ $KEYMAP = vicmd ]]; then
    # the command mode for vi: block shape
    echo -ne "\e]1337;CursorShape=0\x7"
  else
    # the insert mode for vi: line shape
    echo -ne "\e]1337;CursorShape=1\x7"
  fi
  zle reset-prompt
  zle -R
}

# for the mintty terminal
# function zle-keymap-select() {
#   if [[ -n ${TMUX+x} ]]; then
#     if [[ $KEYMAP = vicmd ]]; then
#       # the command mode for vi: block shape
#       echo -ne "\ePtmux;\e\e[2 q\e\\"
#     else
#       # the insert mode for vi: line shape
#       echo -ne "\ePtmux;\e\e[6 q\e\\"
#     fi
#   elif [[ $KEYMAP = vicmd ]]; then
#     # the command mode for vi: block shape
#     echo -ne "\e[2 q"
#   else
#     # the insert mode for vi: line shape
#     echo -ne "\e[6 q"
#   fi
#   zle reset-prompt
#   zle -R
# }

# Updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}

# Ensure that the prompt is redrawn when the terminal size changes.
TRAPWINCH() {
  zle && { zle reset-prompt; zle -R }
}

zle -N zle-keymap-select

bindkey -v

# edit line with vim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'gs' edit-command-line

bindkey -M vicmd '?' history-incremental-search-backward

# since zsh 5.0.8, text objects were introduced. Let's use some of them.
# see here for more info: http://www.zsh.org/mla/workers/2015/msg01017.html
# and here: https://github.com/zsh-users/zsh/commit/d257f0143e69c3724466c4c92f59538d2f3fffd1

# using select-bracketed as intructed on: https://github.com/zsh-users/zsh/blob/master/Functions/Zle/select-bracketed#L6
# same as vim c+motion (change inside/around text-object).
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

# using select-quoted as instructed on: https://github.com/zsh-users/zsh/blob/master/Functions/Zle/select-quoted#L6
# expands c+motion (change inside/around + text-object) to quotes.
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

############# zsh escape code fixes #############

# home key
bindkey "^[[1~" beginning-of-line

# end key
bindkey "^[[4~" end-of-line

# delete key
bindkey "^[[3~" delete-char

# backspace key
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

# numeric keypad return (enter)
bindkey "${terminfo[kent]}" accept-line

# pressing <ESC> in normal mode is bogus: you need to press 'i' twice to enter insert mode again.
# rebinding <ESC> in normal mode to something harmless solves the problem.
bindkey -M vicmd '\e' what-cursor-position

vi-lowercase() {
  local save_cut="$CUTBUFFER" save_cur="$CURSOR"
  zle .vi-change || return
  zle .vi-cmd-mode
  CUTBUFFER="${CUTBUFFER:l}"
  zle .vi-put-after -n 1
  CUTBUFFER="$save_cut" CURSOR="$save_cur"
}

vi-uppercase() {
  local save_cut="$CUTBUFFER" save_cur="$CURSOR"
  zle .vi-change || return
  zle .vi-cmd-mode
  CUTBUFFER="${CUTBUFFER:u}"
  zle .vi-put-after -n 1
  CUTBUFFER="$save_cut" CURSOR="$save_cur"
}

zle -N vi-lowercase
zle -N vi-uppercase

bindkey -a 'gU' vi-uppercase
bindkey -a 'gu' vi-lowercase
bindkey -M visual 'u' vi-lowercase
bindkey -M visual 'U' vi-uppercase

########### vi-like copy and paste on OSx ##########
if [ `uname` = "Darwin" ] && (($+commands[pbcopy])); then
  function cutbuffer() {
    zle .$WIDGET
    echo $CUTBUFFER | pbcopy
  }

  zle_cut_widgets=(
    vi-backward-delete-char
    vi-change
    vi-change-eol
    vi-change-whole-line
    vi-delete
    vi-delete-char
    vi-kill-eol
    vi-substitute
    vi-yank
    vi-yank-eol
  )
  for widget in $zle_cut_widgets
  do
    zle -N $widget cutbuffer
  done

  function putbuffer() {
    zle copy-region-as-kill "$(pbpaste)"
    zle .$WIDGET
  }

  zle_put_widgets=(
    vi-put-after
    vi-put-before
  )
  for widget in $zle_put_widgets
  do
    zle -N $widget putbuffer
  done
fi
