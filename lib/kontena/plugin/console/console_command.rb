require 'kontena/plugin/console'

class Kontena::Plugin::Console::ConsoleCommand < Kontena::Command

  parameter "[CONTEXT] ...", "Jump to context", attribute_name: :context_list

  def execute
    Kontena::Plugin::Console::Session.new(context_list).run
  end
end
