# Abbreviate path by shortening the parent directories.
fn path-abbr [path]{
  if (eq ~ $path) {
    put '~'
  } else {
    # Build a shortened path
    path = (tilde-abbr $path)
    prefix_path = (splits / (dirname $path) | each [fragment]{ put $fragment[0] } | joins /)
    suffix_path = (basename $path)
    shortened_path = $prefix_path/$suffix_path

    put $shortened_path
  }
}
