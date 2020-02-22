// Configuration for Krabby (https://github.com/alexherbo2/krabby/blob/master/src/krabby)

const { env, extensions, modes } = krabby
const { shell, dmenu } = extensions
const { modal } = modes

// Tab search with fzf and Alacritty.
dmenu.send('set-dmenu', {
  command: 'sh',
  arguments: [
    '-c',
    `
      # Create IO files
      state=$(mktemp -d)
      input=$state/input
      output=$state/output
      trap 'rm -Rf "$state"' EXIT
      # Get input from /dev/stdin
      cat > "$input"
      # Run fzf with Alacritty
      alacritty --class 'Alacritty · Floating' --command sh -c 'fzf < "$1" > "$2"' -- "$input" "$output"
      # Write output to /dev/stdout
      cat "$output"
    `
  ]
})

// Override individual configuration options of Alacritty with a temporary config file.
env.EDITOR = `
  # Environment variables
  XDG_CONFIG_HOME=\${XDG_CONFIG_HOME:-~/.config}
  CONFIG=$XDG_CONFIG_HOME/alacritty/alacritty.yml
  # Create a temporary config file
  config=$(mktemp)
  trap 'rm -f "$config"' EXIT
  # Populate configuration if available
  if test -f "$CONFIG"; then
    cp "$CONFIG" "$config"
  fi
  # Additional settings
  cat <<'EOF' >> "$config"
background_opacity: 0.75
EOF
  alacritty --config-file "$config" --class 'Alacritty · Floating' --command kak "$1" -e "select $2.$3,$4.$5"
`

modal.filter('Read Berserk', () => location.hostname === 'readberserk.com', 'Command')
modal.filter('Read Berserk · Chapter', () => location.pathname.startsWith('/chapter'), 'Read Berserk')
modal.enable('Read Berserk · Chapter', 'Read Berserk', ...modal.context.filters)

modal.map('Read Berserk · Chapter', ['KeyM'], () => shell.send('mpv', ...Array.from(document.querySelectorAll('.pages__img'), (image) => image.src)), 'Read Berserk with mpv', 'Read Berserk · Chapter')
