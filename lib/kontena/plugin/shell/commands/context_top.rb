require 'kontena/plugin/shell/command'

module Kontena::Plugin
  module Shell
    class ContextTopCommand < Command
      command '/'
      description 'Clear context'
      help "Go to top in context.\n\nYou can also directly call other commands without switching context first by using for example #{Kontena.pastel.yellow('/ master ls')}"

      def execute
        if args[1] && session
          session.run_command(args[1..-1].join(' '))
        else
          context.top
        end
      end
    end
  end
end
