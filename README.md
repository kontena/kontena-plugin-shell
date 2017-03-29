# Kontena Console

## Installation

Add this to your cli gemfile:

```
gem 'kontena-plugin-console', github: 'kontena/kontena-plugin-console'
```

run `bundle`

Now you should see a "kontena console" subcommand when running 'bin/kontena'.

## Usage

Enter kontena commands without `kontena`:

```
> master ls
```

Go into master context:

```
> master
master > users ls
```

Go up the context:

```
master > ..
>
```

To disable kontena commands:

```
$ KOSH_DISABLED_COMMANDS="master use,grid use" kontena console
```

## Contributing

1. Fork it ( https://github.com/kontena/kontena-plugin-digitalocean )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

Kontena is licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE.txt) for full license text.
