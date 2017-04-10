require_relative 'kontena/plugin/shell'
require_relative 'kontena/plugin/shell/shell_command'
require_relative 'kontena/plugin/shell/callbacks/stack_file'

Kontena::MainCommand.register("shell", "Kontena shell", Kontena::Plugin::Shell::ShellCommand)
