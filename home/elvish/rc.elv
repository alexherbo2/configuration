# Modules ──────────────────────────────────────────────────────────────────────

use re
use command-duration
use git-hub

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

# Language
E:LANG = en_US.UTF-8

# XDG
E:XDG_CONFIG_HOME = ~/.config
E:XDG_CACHE_HOME = ~/.cache
E:XDG_DATA_HOME = ~/.local/share

# Applications
E:TERMINAL = alacritty
E:BROWSER = chromium
E:EDITOR = kak-connect
E:KAK_CLIENT = unnamed0
E:PAGER = kak-pager
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
    if (> $command-duration:value 1) {
      echo (edit:styled (friendly-duration (* $command-duration:value 1000)) cyan) > /dev/tty
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

# Project
fn project {
  attach -tag Terminal elvish > /dev/null
  attach -tag Git elvish > /dev/null
  attach -tag Editor kak
}

# Launcher
fn launch [@commands]{
  (external $@commands) > /dev/null 2> /dev/null &
}

# YouTube
fn youtube-stream {
  echo 'https://youtube.com/channel/UCv9nzkds34PnGOu6u_QvVBQ/live' |
  xclip-selection
  capture video window rtmp://a.rtmp.youtube.com/live2/(get-password alexherbo2@live.youtube.com) flv
}

# GTD
fn diary {
  try {
    socket = (i3 --get-socketpath 2> /dev/null)
    i3-msg --quiet mark Diary
  } except error { }
  cd ~/documents/diary
  attach kak (date +%Y).md
}

# Hijack
fn ipd { e:ipd -4 }
fn kak [@arguments]{ kak-connect $@arguments }
fn ls [@arguments]{ exa $@arguments }
fn tree [@arguments]{ exa --tree $@arguments }
fn cp [@arguments]{ clone $@arguments }
fn rm [@arguments]{ trash $@arguments }
fn grep [@arguments]{ rg $@arguments }
fn gist [@arguments]{ e:gist --open $@arguments }
fn attach [@arguments]{ e:attach -filter 'fzf --query $path' $@arguments }
fn synapse { attach synapse }
fn axon { attach axon }
fn receptor { attach receptor }

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
    ssh mawww -t attach weechat
  } except error {
    attach weechat
  }
}

# Aliases ──────────────────────────────────────────────────────────────────────

fn md [@arguments]{ mkdir --parents $@arguments }
fn c [@arguments]{ clone $@arguments }
fn d [@arguments]{ trash $@arguments }
fn _ [@arguments]{ trash -null $@arguments }
fn x [@arguments]{ extract $@arguments }
fn ft [@arguments]{ file-type $@arguments }

# Listing
fn l [@arguments]{ exa $@arguments }
fn ll [@arguments]{ exa --long $@arguments }
fn la [@arguments]{ exa --all $@arguments }
fn lla [@arguments]{ exa --long --all $@arguments }
fn t [@arguments]{ exa --tree $@arguments }

# Browser
fn b [@arguments]{ launch chromium $@arguments }

# Kakoune
fn k [@arguments]{ kak-connect $@arguments }

# Git
fn g [@arguments]{ git $@arguments }
fn G [@arguments]{ tig $@arguments }
fn gh [@arguments]{ git-hub $@arguments }
fn gcd { git-hub:change-directory . }

# mpv
fn m [@arguments]{ mpv $@arguments }
fn mi [@arguments]{ mpv -profile image $@arguments }
fn ma [@arguments]{ mpv -profile audio $@arguments }

fn y [@arguments]{ youtube-dl $@arguments }
fn v2g [@arguments]{ video-to-gif $@arguments }

# Brown noise
fn i { isolate }

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
