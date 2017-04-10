require 'kontena/plugin/shell'

class Kontena::Plugin::Shell::ShellCommand < Kontena::Command

  parameter "[CONTEXT] ...", "Jump to context", attribute_name: :context_list

  def execute
    Kontena::Plugin::Shell::Session.new(context_list).run
  end
end
