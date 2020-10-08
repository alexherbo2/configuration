# git
# https://git-scm.com
#
# Provide various Git commands and aliases.
#
# Commands
#
# – git (g): Git.
# – git-write (gw): Save the file and add it to Git.
# – git-write-force (gw!): Save the file and force-add it to Git.
# – git-commit (gc): Git commit.
# – git-reword (gr): Git reword commit.

provide-module git %{
  alias global g git

  define-command git-write -docstring 'Save the file and add it to Git' %{
    write
    git add
  }

  alias global gw git-write

  define-command git-write-force -docstring 'Save the file and force-add it to Git' %{
    write
    nop %sh(git add --force "$kak_buffile")
  }

  alias global gw! git-write-force

  define-command git-commit -docstring 'Git commit' %{
    git commit
  }

  alias global gc git-commit

  define-command git-reword -docstring 'Git reword commit' %{
    git commit --amend
  }

  alias global gr git-reword
}
