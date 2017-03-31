require_relative 'kontena/plugin/console'
require_relative 'kontena/plugin/console/console_command'
require_relative 'kontena/plugin/console/callbacks/stack_file'

Kontena::MainCommand.register("console", "Kontena shell", Kontena::Plugin::Console::ConsoleCommand)
