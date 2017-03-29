require_relative 'kontena/plugin/console'
require_relative 'kontena/plugin/console/console_command'

Kontena::MainCommand.register("console", "Kontena shell", Kontena::Plugin::Console::ConsoleCommand)
