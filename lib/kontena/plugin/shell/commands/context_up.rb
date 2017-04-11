require 'kontena/plugin/shell/command'

module Kontena::Plugin
  module Shell
    class ContextUpCommand < Command
      command '..'
      description 'Go up in context'
      help 'Go up in context'

      def execute
        context.up
      end
    end
  end
end
