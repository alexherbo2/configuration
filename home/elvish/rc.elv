# Modules ──────────────────────────────────────────────────────────────────────

# regexp
# https://elv.sh/ref/re.html
use re

# path-abbr
use github.com/alexherbo2/path-abbr.elv/lib/path-abbr

# Kakoune
# https://kakoune.org
use github.com/alexherbo2/kakoune.elv/lib/kakoune

# Broot
# https://dystroy.org/broot/
use github.com/alexherbo2/broot.elv/lib/broot

# Functions ────────────────────────────────────────────────────────────────────

# Broot
# https://dystroy.org/broot/
fn br [@arguments]{
  broot:br $@arguments
}

# Change directory ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# git-hub
# https://github.com/alexherbo2/git-hub
fn gcd {
  cd (git-hub-list | fzf)
}

# Kakoune
# https://kakoune.org
#
# Buffer directory
fn kcd {
  cd (:bwd)
}

# Working directory
fn Kcd {
  cd (:pwd)
}

# Aliases ──────────────────────────────────────────────────────────────────────

# cat → bat
# https://github.com/sharkdp/bat
fn cat [@arguments]{
  bat $@arguments
}

# cp → clone
# https://github.com/alexherbo2/clone
fn cp [@arguments]{
  clone $@arguments
}

# curl
# https://curl.haxx.se
fn curl [@arguments]{
  e:curl -sSL $@arguments
}

# find → fd
# https://github.com/sharkdp/fd
fn find [@arguments]{
  fd $@arguments
}

# grep → ripgrep
# https://github.com/BurntSushi/ripgrep
fn grep [@arguments]{
  rg $@arguments
}

# ls → broot
# https://dystroy.org/broot/
#
# Replace ls and its clones
# https://dystroy.org/broot#replace-ls-and-its-clones
fn ls [@arguments]{
  br --sizes --dates --permissions $@arguments
}

# Pandoc
# https://pandoc.org
#
# Use Tectonic as PDF engine
# https://tectonic-typesetting.github.io
fn pandoc [@arguments]{
  e:pandoc --pdf-engine tectonic $@arguments
}

# rm → trash
# https://github.com/alexherbo2/trash
fn rm [@arguments]{
  trash $@arguments
}

fn su [@arguments]{
  sudo --login $@arguments
}

fn wget [@arguments]{
  e:wget --continue $@arguments
}

# Key-bindings ─────────────────────────────────────────────────────────────────

# Delete words
edit:insert:binding[Alt-Backspace] = { edit:kill-small-word-left }
edit:insert:binding[Alt-Delete] = { edit:kill-small-word-right }

# Move your cursor around
edit:insert:binding[Alt-Left] = { edit:move-dot-left-word }
edit:insert:binding[Alt-Right] = { edit:move-dot-right-word }
edit:insert:binding[Alt-Shift-Left] = { edit:move-dot-left-word }
edit:insert:binding[Alt-Shift-Right] = { edit:move-dot-right-word }

# Navigation
edit:insert:binding[Alt-l] = { edit:location:start }
edit:insert:binding[Alt-n] = { edit:navigation:start }

# Clear the screen
edit:insert:binding[Ctrl-l] = { clear > /dev/tty }

# History – Next
edit:insert:binding[Ctrl-n] = { edit:history:start }
edit:history:binding[Ctrl-n] = { edit:history:down }

# History – Previous
edit:insert:binding[Ctrl-p] = { edit:history:start }
edit:history:binding[Ctrl-p] = { edit:history:up }

# Starship ─────────────────────────────────────────────────────────────────────

# https://starship.rs

eval (starship init elvish)
