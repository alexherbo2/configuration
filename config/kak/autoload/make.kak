# make
# Provide various make aliases.
#
# Aliases
#
# – make-next-error (mn)
# – make-previous-error (mp)

provide-module make %{
  alias global mn make-next-error
  alias global mp make-previous-error
}
