# Modules ──────────────────────────────────────────────────────────────────────

use re
use github.com/zzamboni/elvish-modules/alias

# Environment variables ────────────────────────────────────────────────────────

paths = [
  ~/configuration/bin
  ~/configuration/local/bin
  ~/configuration/install/bin
  ~/configuration/src/crystal/bin
  ~/.bin
  ~/.local/bin
  (ruby -e 'puts Gem.user_dir')/bin
  ~/.cargo/bin
  ~/.cabal/bin
  ~/go/bin
  node_modules/.bin
  ~/.npm-packages/bin
  $@paths
]

E:MANPATH = ~/.npm-packages/share/man:

# Shell
E:SHELL = elvish

# XDG
E:XDG_CONFIG_HOME = ~/.config
E:XDG_CACHE_HOME = ~/.cache
E:XDG_DATA_HOME = ~/.local/share

# Applications
E:BROWSER = chromium
E:KAKOUNE_POSIX_SHELL = /run/current-system/sw/bin/dash
E:MANPAGER = kak-man-pager
E:GIT_HUB = ~/repositories

# ripgrep
E:RIPGREP_CONFIG_PATH = $E:XDG_CONFIG_HOME/ripgrep/rc

# fzf
E:FZF_DEFAULT_OPTS = '--multi --reverse'

# dmenu
E:DMENU = '
  # Create IO files
  state=$(mktemp -d)
  input=$state/input
  output=$state/output
  trap ''rm -Rf "$state"'' EXIT
  # Get input from /dev/stdin
  cat > "$input"
  # Run fzf with Alacritty
  alacritty --class ''Alacritty · Floating'' --command sh -c ''fzf < "$1" > "$2"'' -- "$input" "$output"
  # Write output to /dev/stdout
  cat "$output"
  # Exit code
  if test ! -s "$output"; then
    exit 1
  fi
'

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

# Batch

fn batch [@arguments]{
  e:batch --editor kak $@arguments
}

fn batch-rename [@arguments]{
  batch --map 'rename "$1" "$2"' $@arguments
}

fn batch-convert [@arguments]{
  batch --map 'convert "$1" "$2"' $@arguments
}

fn batch-relink [@arguments]{
  batch --map 'relink "$1" "$2"' $@arguments
}

# Chronic
alias:new cr chronic

# Aliases ──────────────────────────────────────────────────────────────────────

alias:new p echo
alias:new md mkdir -p
alias:new c clone
alias:new d trash
alias:new _ trash
alias:new x arc unarchive
alias:new ft mime
alias:new yk wl-copy

# Listing
alias:new l exa
alias:new ll exa --long
alias:new la exa --all
alias:new lla exa --long --all
alias:new L exa --tree

# Browser
alias:new b chromium

# tmux
alias:new t tmux
alias:new tn tmux new-session
alias:new ta tmux attach-session

# Kakoune
alias:new k kak
alias:new ks kak -s '{}' -d ';' kak -c '{}'
alias:new kc kak -c
alias:new kl kak -l
alias:new kn kak -n
alias:new kh kak -help

# Git
alias:new g git
alias:new G tig

alias:new gcp git-hub-clone
alias:new gls git-hub-list
alias:new gupdate git-hub-update
alias:new gpipe git-hub-pipe
alias:new gcd cd '(git-hub-list | fzf)'

# mpv
alias:new m mpv
alias:new mi mpv -profile image
alias:new ma mpv -profile audio
alias:new mkwa mpv -profile audio "(radiokawa '' '#{item.enclosure.url}')"

alias:new y youtube-dl
alias:new dls youtube-dl-source
alias:new v2g ffmpeg-to-gif

# wf-recorder
alias:new wf wf-recorder -f "(new-file '' .mkv)"

# synapse
alias:new scu synapse-unfinished

# Brown noise
alias:new i isolate

# Batch
fn rn [@arguments]{ batch-rename $@arguments }
fn cv [@arguments]{ batch-convert $@arguments }
fn rl [@arguments]{ batch-relink $@arguments }

# Password
alias:new pm password-get '(password-menu | fzf)' '|' wl-copy
alias:new pc password-create
alias:new pg password-get
alias:new pe password-edit

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
