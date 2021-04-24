# Search something.
#
# Usage:
#
# Enter `search` and start typing to search.
# Press `Tab` to skim through the occurrences.
#
# Configuration:
#
# map -docstring 'Search plain text' global normal f ':search<ret>(?i)\Q'
# map -docstring 'Search' global normal F ':search<ret>'
#
# Faces:
#
# - SearchBackground
# - SearchOccurrence

# Internal variables
declare-option -hidden str-list search_register
declare-option -hidden str-list search_selections

# Public faces
set-face global SearchBackground white
set-face global SearchOccurrence yellow+b

# Search command
define-command -override search -docstring 'Search' %{
  # Save values
  set-option window search_register %reg{/}
  set-option window search_selections %val{selections_desc}

  # Paint background
  add-highlighter window/search-background fill SearchBackground

  # Internal mappings
  map window prompt <tab> '<a-;>n'
  map window prompt <s-tab> '<a-;><a-n>'

  # Clean up when leaving the prompt
  hook -once window ModeChange pop:prompt:normal %{
    unmap window prompt
    remove-highlighter window/search-occurrence
    remove-highlighter window/search-background
  }

  # Enter search
  prompt search: 'set-register / %val{text}' -on-change 'set-register / %val{text}; add-highlighter -override window/search-occurrence regex %val{text} 0:SearchOccurrence' -on-abort 'set-register / %opt{search_register}; select %opt{search_selections}'
}

# Mappings
map -docstring 'Search plain text' global normal f ':search<ret>(?i)\Q'
map -docstring 'Search' global normal F ':search<ret>'
