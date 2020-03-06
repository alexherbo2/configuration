// Configuration for Krabby (https://github.com/alexherbo2/krabby/blob/master/src/krabby)

const { extensions, modes } = krabby
const { commands, shell, dmenu, editor } = extensions
const { modal } = modes

// Show keys for screencasts
const showKeys = () => {
  modal.on('command', ({ keyChord, description, label }) => {
    const keys = modal.keyValues(keyChord)
    const key = keys.join('-')
    commands.send('notify', 'show-keys', {
      title: label,
      message: `${key}: ${description}`
    })
  })
}

// Tab search with fzf and Alacritty.
dmenu.send('set', {
  dmenu: {
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
        # Exit code
        if test ! -s "$output"; then
          exit 1
        fi
      `
    ]
  }
})

// External editor
editor.send('set', {
  editor: `alacritty --class 'Alacritty · Floating' --command kak "$file" -e "select $anchor_line.$anchor_column,$cursor_line.$cursor_column"`
})

modal.filter('Read Berserk', () => location.hostname === 'readberserk.com', 'Command')
modal.filter('Read Berserk · Chapter', () => location.pathname.startsWith('/chapter'), 'Read Berserk')
modal.enable('Read Berserk · Chapter', 'Read Berserk', ...modal.context.filters)

modal.map('Read Berserk · Chapter', ['KeyM'], () => shell.send('mpv', ...Array.from(document.querySelectorAll('.pages__img'), (image) => image.src)), 'Read Berserk with mpv', 'Read Berserk · Chapter')
