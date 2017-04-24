require 'pathname'
path = Pathname.new(__FILE__).dirname.realpath.to_s
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'kontena_cli' unless Object.const_defined?(:Kontena) && Kontena.const_defined?(:Cli)

require 'kontena/plugin/shell'
require 'kontena/plugin/shell/shell_command'

Kontena::MainCommand.register("shell", "Kontena shell", Kontena::Plugin::Shell::ShellCommand)
