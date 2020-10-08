# edit
# Provide various edit commands.
#
# Dependencies
#
# – fd (https://github.com/sharkdp/fd)
#
# Commands
#
# – find-edit (f): Edit file.
# – find-edit-all (fa): Edit file.
# – scratch (s): Create a scratch buffer.
# – scratch-reload (s!): Reload the scratch buffer.
# – read-only (ro): Make the buffer read-only.

provide-module edit %{
  define-command find-edit -params 1 -shell-script-candidates 'fd --type file' -docstring 'Edit file' %{
    edit %arg{1}
  }

  alias global f find-edit

  define-command find-edit-all -params 1 -shell-script-candidates 'fd --hidden --no-ignore --type file' -docstring 'Edit file' %{
    edit %arg{1}
  }

  alias global fa find-edit-all

  define-command scratch -docstring 'Create a scratch buffer' %{
    edit -scratch '*scratch*'
  }

  alias global s scratch

  define-command scratch-reload -docstring 'Reload the scratch buffer' %{
    edit! -scratch '*scratch*'
  }

  alias global s! scratch-reload

  define-command read-only -docstring 'Make the buffer read-only' %{
    edit -readonly %val{bufname}
  }

  alias global ro read-only
}
