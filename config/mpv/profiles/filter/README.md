# mpv – filter

Print the current filename to **stdout** on <kbd>Enter</kbd>.
Useful for piping to other applications.

**Example** – Remove files on <kbd>Enter</kbd>:

``` sh
mx | xargs rm
```

## Configuration

Add an alias to your bashrc:

``` bash
alias mx='mpv -config-dir="$XDG_CONFIG_HOME/mpv/profiles/filter"'
```

## Credits

Original idea from [meh].

[meh]: https://johnhawthorn.com/meh/
