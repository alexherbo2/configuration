# grep
# Provide various grep aliases.
#
# Aliases
#
# – grep-next-match (gn)
# – grep-previous-match (gp)

provide-module grep %{
  alias global gn grep-next-match
  alias global gp grep-previous-match
}
