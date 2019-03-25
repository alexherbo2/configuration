# Modules ──────────────────────────────────────────────────────────────────────

use re
use github.com/alexherbo2/command-duration.elv/lib/command-duration
use github.com/alexherbo2/git-hub/contrib/elvish/lib/git-hub
use github.com/zzamboni/elvish-modules/alias

# Environment variables ────────────────────────────────────────────────────────

paths = [
  ~/configuration/bin
  ~/configuration/local/bin
  ~/configuration/install/bin
  ~/.bin
  ~/.local/bin
  (ruby -e 'puts Gem.user_dir')/bin
  ~/.cargo/bin
  ~/.cabal/bin
  ~/go/bin
  ~/node_modules/.bin
  $@paths
]

# Shell
E:SHELL = elvish

# Language
E:LANG = en_US.UTF-8

# XDG
E:XDG_CONFIG_HOME = ~/.config
E:XDG_CACHE_HOME = ~/.cache
E:XDG_DATA_HOME = ~/.local/share

# Applications
E:TERMINAL = kitty
E:BROWSER = chromium
E:KAKOUNE_POSIX_SHELL = /run/current-system/sw/bin/dash
E:MANPAGER = kak-man-pager
E:GREPER = rg
E:FILTER = fzf
E:REMOVER = trash
E:GIT_HUB = ~/repositories

# ripgrep
E:RIPGREP_CONFIG_PATH = $E:XDG_CONFIG_HOME/ripgrep/rc

# fzf
E:FZF_DEFAULT_OPTS = '--multi --reverse'

# Prompt ───────────────────────────────────────────────────────────────────────

# ❯ echo Tchou                       alex at othala in ~/configuration on master

edit:prompt = {
  put '❯ '
}

edit:rprompt = {
  edit:styled (whoami) magenta
  put ' at '
  edit:styled (hostname) yellow
  put ' in '
  edit:styled (tilde-abbr $pwd) green
  try {
    branch = (git rev-parse --abbrev-ref HEAD)
    status = (git status --porcelain | slurp)
    put ' on '
    edit:styled $branch magenta
    # [?] → Unstaged changes
    # [!] → Ready to commit
    if (re:match '(?m)^.\S' $status) {
      edit:styled '?' green
    } elif (re:match '(?m)^.\s' $status) {
      edit:styled '!' green
    }
  } except error { } 2> /dev/null
}

# Hooks ────────────────────────────────────────────────────────────────────────

# Display user-friendly durations
edit:before-readline = [
  $@edit:before-readline
  {
    if (> $command-duration:value 60) {
      echo (edit:styled (
        printf 'Finished in %s (%s)' \
          (friendly-duration (* $command-duration:value 1000)) \
          (date +'%a %b %-d %-I:%M %p') \
      ) cyan) > /dev/tty
    }
  }
]

# Commands ─────────────────────────────────────────────────────────────────────

# Hit Enter to repeat the last command
fn enter {
  last-command = [(edit:command-history)][-1][cmd]
  if (eq '' $edit:current-command) {
    edit:current-command = $last-command
  }
  edit:smart-enter
}

# Thanks to Diego Zamboni to show me the initial implementation,
# on #elvish the 2018-03-14 at 17:40:20.
# https://github.com/zzamboni

# GTD
fn diary {
  try {
    socket = (i3 --get-socketpath 2> /dev/null)
    i3-msg --quiet mark Diary
  } except error { }
  cd ~/documents/diary
  kak (date +%Y).md
}

# Hijack
alias:new su sudo --login
alias:new ipd e:ipd -4
alias:new cat bat
alias:new ls exa
alias:new tree exa --tree
alias:new cp clone
alias:new rm trash
alias:new grep rg
# Configure curl to be quiet (but not silent)
alias:new curl e:curl --silent --show-error --location
alias:new wget e:wget --continue
alias:new gist e:gist --open

fn kak [@arguments]{
  if ?(test $E:KAKOUNE_PROFILE == asciinema) {
    kak-asciinema $@arguments
  } else {
    e:kak $@arguments
  }
}

fn git-init [directory]{
  git init $directory
  cd $directory
  repository = (basename $directory)
  git remote add origin git@github.com:alexherbo2/$repository
  git remotes
}

fn mpv [@arguments]{
  try {
    socket = (i3 --get-socketpath 2> /dev/null)
    i3-msg --quiet mark mpv
  } except error { }
  e:mpv $@arguments
}

fn weechat {
  try {
    socket = (i3 --get-socketpath 2> /dev/null)
    i3-msg --quiet mark IRC
  } except error { }
  try {
    ssh mawww -t weechat
  } except error {
    e:weechat
  }
}

# Aliases ──────────────────────────────────────────────────────────────────────

alias:new md mkdir --parents
alias:new c clone
alias:new d trash
alias:new _ trash -null
alias:new x extract
alias:new ft file-type
alias:new yk xclip-selection
alias:new 640px i3-resize 640px 400px

# Listing
alias:new l exa
alias:new ll exa --long
alias:new la exa --all
alias:new lla exa --long --all
alias:new t exa --tree

# Browser
alias:new b launch chromium

# Kakoune
alias:new k kak-connect
alias:new kl kak-list

# Git
alias:new g git
alias:new G tig
fn gi [@arguments]{ git-init $@arguments }
fn gh [@arguments]{ git-hub $@arguments }
fn gcd { git-hub:change-directory . }

# mpv
alias:new m mpv
alias:new mi mpv -profile image
alias:new ma mpv -profile audio
alias:new mkwa mpv -profile audio "(radio-kawa '' '#{item.enclosure.url}')"

alias:new y youtube-dl
alias:new dls youtube-dl-source
alias:new v2g video-to-gif

# synapse
alias:new scu synapse-unfinished

# Brown noise
alias:new i isolate

# Key-bindings ─────────────────────────────────────────────────────────────────

# Navigation
edit:insert:binding[Alt-l] = { edit:location:start }
edit:insert:binding[Alt-n] = { edit:navigation:start }

# Enter to repeat last command
edit:insert:binding[Enter] = $enter~

# Clear
edit:insert:binding[Ctrl-l] = { clear > /dev/tty }

# Next / Previous
edit:insert:binding[Ctrl-n] = { edit:history:start }
edit:history:binding[Ctrl-n] = { edit:history:down }

edit:insert:binding[Ctrl-p] = { edit:history:start }
edit:history:binding[Ctrl-p] = { edit:history:up }

-exports- = (alias:export)
