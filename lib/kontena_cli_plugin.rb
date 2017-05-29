require 'pathname'
path = Pathname.new(__FILE__).dirname.realpath.to_s
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'kontena_cli' unless Object.const_defined?(:Kontena) && Kontena.const_defined?(:Cli)

require 'kontena/plugin/shell'
require 'kontena/cli/subcommand_loader'

Kontena::MainCommand.register("shell", "Kontena shell", Kontena::Cli::SubcommandLoader.new('kontena/plugin/shell/shell_command'))
