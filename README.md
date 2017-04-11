# Kontena Shell

[![asciicast](kosh.gif)](https://asciinema.org/a/58j375bs9zqn3x33wsir7drsa)

Kontena Shell, or KOSH for short, is an interactive console interface for the [Kontena CLI](https://github.com/kontena/kontena).

Features:

- Command context switching, for example jump to stack context and use "ls" and "install" instead of "kontena stack ls" and "kontena stack install"
- Prompt shows current master and grid
- Command history
- Batch commands
- Tab completion
- ...

## Installation

```
kontena plugin install shell
```

## Usage

Starting the console:

```
$ kontena shell
```

or:

```
kosh
```

You can enter regular Kontena CLI subcommands without `kontena`:

```
kontena-master/grid-name > master ls
Name                     Url
kontena-master           http://192.168.66.100:8080
```

Or enter a command context:

```
> grid
kontena-master/grid-name grid > use foo
kontena-master/foo grid > _
```

To go up in the context, use '..':

```
kontena-master/foo grid > ..
kontena-master/foo > ..
```

Or go to top with '/':

```
kontena-master/foo > master user
kontena-master/foo master user > /
kontena-master/foo > _
```

Use 'help' to see help:

```
kontena-master/foo grid > help
Usage:
      SUBCOMMAND [ARG] ...

Parameters:
    SUBCOMMAND                    subcommand
    [ARG] ...                     subcommand arguments
...
```

## Contributing

1. Fork it ( https://github.com/kontena/kontena-plugin-shell )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

Kontena Shell Plugin is licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE.txt) for full license text.
