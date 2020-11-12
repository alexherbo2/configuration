// Configuration for Krabby (https://github.com/alexherbo2/krabby/blob/master/src/krabby)

const { extensions, modes, settings } = krabby
const { commands, shell, dmenu, editor } = extensions
const { modal } = modes

// Show keys for screencasts
const showKeys = () => {
  modal.on('command', ({ keyChord, description, label }) => {
    const keys = modal.keyValues(keyChord)
    const key = keys.join('-')
    commands.send('notify', 'show-keys', {
      title: label,
      message: `${key} ⇒ ${description}`
    })
  })
  // Show native commands
  modal.on('default', ({ metaKey, altKey, ctrlKey, shiftKey, code }) => {
    const keyChord = { metaKey, altKey, ctrlKey, shiftKey, code }
    const keys = modal.keyValues(keyChord)
    const key = keys.join('-')
    commands.send('notify', 'show-keys', {
      title: 'Native',
      message: key
    })
  })
}

// Enable show-keys notifications
// showKeys()

// Link hints
settings['hint-selectors'] = ':not(.krabby)'

// Tab search with Wofi.
dmenu.send('set', {
  dmenu: {
    command: 'wofi',
    arguments: ['--show', 'dmenu']
  }
})

// External editor
editor.send('set', {
  editor: `
    wezterm start -- \\
      kak "$file" -e "
        select $anchor_line.$anchor_column,$cursor_line.$cursor_column
      "
  `
})
