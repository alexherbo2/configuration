function print_path()
  mp.set_property('msg-level', 'cplayer=info')
  mp.commandv('print-text', mp.get_property('path'))
  mp.set_property('msg-level', 'all=no')
end

mp.add_key_binding(nil, 'print-path', print_path)
