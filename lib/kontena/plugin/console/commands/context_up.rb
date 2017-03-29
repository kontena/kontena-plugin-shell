module Kontena::Plugin
  module Console
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
