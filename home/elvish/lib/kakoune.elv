# Kakoune
# https://kakoune.org

# Edit the current command with Kakoune
#
# Mappings
# Escape ⇒ Quit
# Return ⇒ Write and quit
fn edit-command-line {
  command_path = (mktemp)
  print $edit:current-command > $command_path

  # Edit the current command with Kakoune
  kak $command_path -e '
    # Mappings
    map global normal <esc> :quit<ret>
    map global normal <ret> :write-quit<ret>

    # Place the cursor
    execute-keys '$edit:-dot' l
  ' < /dev/tty > /dev/tty 2>&1

  edit:current-command = (cat $command_path | slurp)
  rm -f $command_path
}

# Mappings
# Escape ⇒ Edit the current command with Kakoune
edit:insert:binding['Ctrl-['] = $edit-command-line~
