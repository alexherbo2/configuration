require "yaml"

CONFIG = File.join(
  ENV["XDG_CONFIG_HOME"],
  "passwords.yml"
)

alias Passwords = Hash(String, Array(String))

passwords = File.open(CONFIG) do |file|
  Passwords.from_yaml(file)
end

key = ARGV.first
puts passwords[key].last
