require "yaml"

CONFIG = File.join(
  ENV["XDG_CONFIG_HOME"],
  "passwords.yml"
)

alias Passwords = Hash(String, Array(String))

passwords = File.open(CONFIG) do |file|
  Passwords.from_yaml(file)
end

case ARGV.size
when 0
  puts passwords.keys.join('\n')
when 1
  key = ARGV.first
  puts passwords[key].last
end
