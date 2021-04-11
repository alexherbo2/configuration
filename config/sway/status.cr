require "json"

# Status line for Sway.
#
# It was written in Crystal with the goal of using as few syscalls as possible.
#
# Usage:
#
# bar {
#   status_command crystal ~/.config/sway/status.cr
# }
#
# Protocol: https://github.com/swaywm/sway/blob/master/swaybar/swaybar-protocol.7.scd

# Color palette
# https://github.com/dracula/dracula-theme#color-palette
black = "#282a36"
gray = "#44475a"
white = "#f8f8f2"
blue = "#6272a4"
cyan = "#8be9fd"
green = "#50fa7b"
orange = "#ffb86c"
pink = "#ff79c6"
purple = "#bd93f9"
red = "#ff5555"
yellow = "#f1fa8c"

# Write the status line to standard output.
spawn do
  header = { version: 1, click_events: true }

  puts(header.to_json, "[")

  loop do
    status_line = [
      { :name => "terminal", :full_text => "", :color => black },
      { :name => "file-manager", :full_text => "", :color => pink },
      { :name => "web-browser", :full_text => "", :color => purple },
      { :name => "battery", :full_text => "%s%%" % File.open("/sys/class/power_supply/BAT1/capacity").gets },
      { :name => "time", :full_text => Time.local.to_s("%A %F %R") }
    ]

    puts(status_line.to_json, ",")
    sleep(10)
  end
end

# Read events from standard input.
spawn do
  # Skips "["
  STDIN.gets

  STDIN.each_line do |line|
    # Strips "," to parse a valid chunk.
    click_event = JSON.parse(line.strip(','))

    # Pinned applications
    # Note: Pass the command to `swaymsg` so that the resulting window can be opened
    # on the original workspace that the command was run on.
    case { click_event["name"], click_event["button"] }
    when { "terminal", 1 }
      Process.run("swaymsg", { "exec", "alacritty" })
    when { "file-manager", 1 }
      Process.run("swaymsg", { "exec", "dolphin" })
    when { "web-browser", 1 }
      Process.run("swaymsg", { "exec", "chromium" })
    end
  end
end

sleep
