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

# Prompt ───────────────────────────────────────────────────────────────────────

# Prompt
edit:prompt = {
  # NixOS
  # https://nixos.org
  if (not-eq '' $E:IN_NIX_SHELL) {
    styled λ green
  }

  # Kakoune
  # https://kakoune.org
  if (eq 1 $E:IN_KAKOUNE_CONNECT) {
    styled 🐈 yellow
    put '('

    # Client and session
    if (not-eq '' $E:KAKOUNE_CLIENT) {
      styled $E:KAKOUNE_CLIENT magenta
      put @
      styled $E:KAKOUNE_SESSION yellow

    # Session
    } else {
      styled $E:KAKOUNE_SESSION yellow
    }

    # Kakoune info closing
    put ')'
  }

  # Git
  # https://git-scm.com
  if ?(git rev-parse 2> /dev/null) {
    styled 🐙 red
    put '('

    # Reference
    # https://alexherbo2.github.io/wiki/git/info/
    #
    # Handle repositories with no commit yet.
    branch = HEAD
    try {
      branch = (git rev-parse --abbrev-ref HEAD)
    } except error { } 2> /dev/null
    status = (git status --porcelain | slurp)

    # Branch
    styled $branch magenta

    # Status
    # "?" ⇒ Unstaged changes
    if (re:match '(?m)^.\S' $status) {
      styled '?' green italic

    # "!" ⇒ Ready to commit
    } elif (re:match '(?m)^.\s' $status) {
      styled '!' green italic
    }

    # Git info closing
    put ')'
  }

  # Working directory
  styled (path-abbr:path-abbr $pwd) blue

  # Prompt
  styled : bold
}

# Remove the default right prompt
edit:rprompt = {
}

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
