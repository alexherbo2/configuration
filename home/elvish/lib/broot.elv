# Broot
# https://dystroy.org/broot/

fn br [@arguments]{
  command_path = (mktemp)
  broot --outcmd $command_path $@arguments
  -source $command_path
  rm -f $command_path
}
