// Configuration for Krabby (https://github.com/alexherbo2/krabby/blob/master/src/krabby.js)

const { env, extensions, modes } = krabby
const { shell } = extensions
const { modal } = modes

env.EDITOR = 'kitty kak "$1" -e "select $2.$3,$4.$5"'

modal.filter('Read Berserk', () => location.hostname === 'readberserk.com', 'Command')
modal.filter('Read Berserk · Chapter', () => location.pathname.startsWith('/chapter'), 'Read Berserk')
modal.enable('Read Berserk · Chapter', 'Read Berserk', ...modal.context.filters)

modal.map('Read Berserk · Chapter', ['KeyM'], () => shell.send('mpv', ...Array.from(document.querySelectorAll('.pages__img'), (image) => image.src)), 'Read Berserk with mpv', 'Read Berserk · Chapter')
