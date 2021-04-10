require "json"

# Status line for Sway.
#
# Usage:
#
# bar {
#   status_command crystal ~/.config/sway/status.cr
# }
#
# Protocol: https://github.com/swaywm/sway/blob/master/swaybar/swaybar-protocol.7.scd

# Write the status line to standard output.
spawn do
  header = { version: 1 }

  puts(header.to_json, "[")

  loop do
    status_line = [
      { :name => "battery", :full_text => "%s%%" % File.open("/sys/class/power_supply/BAT1/capacity").gets },
      { :name => "time", :full_text => "%s" % Time.local.to_s("%R") }
    ]

    puts(status_line.to_json, ",")
    sleep(10)
  end
end

# Read events from standard input.
spawn do
end

sleep
