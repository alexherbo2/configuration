# gtd
#
# Provide various “Getting Things Done” related commands.
#
# https://en.wikipedia.org/wiki/Getting_Things_Done
#
# Recommended plugins
#
# – chronic.kak (https://github.com/alexherbo2/chronic.kak)
#
# Mappings
#
# Normal mode
#
# – Alt + d ⇒ Search dates (YYYY-MM-DD) from today.
# – Control + d ⇒ TODO → DONE.
# – Control + u ⇒ TODO → CANCELED.
#
# Insert mode
#
# – Control + y ⇒ Insert date.
# – Control + u ⇒ Insert time.

provide-module gtd %{
  # Modes ──────────────────────────────────────────────────────────────────────

  # Enable GTD
  define-command gtd-enable -docstring 'Enable GTD' %{
    # Highlighters
    add-highlighter global/gtd ref gtd

    # Completion
    evaluate-commands set-option -add global static_words %opt{gtd_keywords}

    # Mappings
    map -docstring 'Search dates (YYYY-MM-DD) from today' global normal <a-d> ': gtd-search-dates-from-today<ret>'
    map -docstring 'TODO → DONE' global normal <c-d> ': gtd-todo-done<ret>'
    map -docstring 'TODO → CANCELED' global normal <c-u> ': gtd-todo-canceled<ret>'
    map -docstring 'Insert date' global insert <c-y> '<a-;>: gtd-insert-date<ret>'
    map -docstring 'Insert time' global insert <c-u> '<a-;>: gtd-insert-time<ret>'
  }

  # Disable GTD
  define-command gtd-disable -docstring 'Disable GTD' %{
    # Highlighters
    remove-highlighter global/gtd

    # Completion
    evaluate-commands set-option -remove global static_words %opt{gtd_keywords}

    # Mappings
    unmap global normal <a-d>
    unmap global normal <c-d>
    unmap global normal <c-u>
    unmap global insert <c-y>
    unmap global insert <c-u>
  }

  # Highlighters ───────────────────────────────────────────────────────────────

  # Declaration
  add-highlighter shared/gtd regions
  add-highlighter shared/gtd/code default-region group

  # Keywords
  declare-option -hidden str-list gtd_keywords 'CANCELED' 'DEADLINE' 'DONE' 'FIXME' 'POSTPONED' 'SCHEDULED' 'TODO'

  # Highlight keywords
  evaluate-commands %sh{
    set -- $kak_opt_gtd_keywords
    regex="\\b(?:\\Q$1\\E"
    shift
    for keyword do
      regex="$regex|\\Q$keyword\\E"
    done
    regex="$regex)\\b"

    printf 'add-highlighter shared/gtd/code/keywords regex "%s" 0:keyword' "$regex"
  }

  # Commands ───────────────────────────────────────────────────────────────────

  # Actions ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

  # TODO → DONE
  define-command gtd-todo-done -docstring 'TODO → DONE' %{
    execute-keys -draft '<a-x>sTODO<ret>cDONE<esc>'
  }

  # TODO → CANCELED
  define-command gtd-todo-canceled -docstring 'TODO → CANCELED' %{
    execute-keys -draft '<a-x>sTODO<ret>cCANCELED<esc>'
  }

  # Search ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

  # Grep TODO
  define-command gtd-grep-todo -docstring 'Grep TODO' %{
    grep TODO
  }

  alias global todo gtd-grep-todo

  # Search dates (YYYY-MM-DD) from today
  define-command gtd-search-dates-from-today -docstring 'Search dates (YYYY-MM-DD) from today' %{
    set-register / %sh(date '+%F')
    execute-keys '<space>n'
    set-register / '\d{4}-\d{2}-\d{2}'
  }

  # Insert ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

  # Insert date
  define-command gtd-insert-date -docstring 'Insert date' %{
    execute-keys -draft '!date ''+%F'' | tr -d ''\n''<ret>'
  }

  # Insert time
  define-command gtd-insert-time -docstring 'Insert time' %{
    execute-keys -draft '!date ''+%R'' | tr -d ''\n''<ret>'
  }
}
