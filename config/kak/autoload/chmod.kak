# chmod
# chmod integration.

provide-module chmod %{
  define-command chmod -params .. -docstring 'Change access permissions of the current file' %{
    nop %sh{
      chmod "$@" "$kak_buffile"
    }
  }
}
