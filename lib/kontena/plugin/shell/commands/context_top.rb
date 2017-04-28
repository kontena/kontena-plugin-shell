require 'kontena/plugin/shell/command'

module Kontena::Plugin
  module Shell
    class ContextTopCommand < Command
      command '/'
      description 'Clear context'
      help "Go to top in context.\n\nYou can also directly call other commands without switching context first by using for example #{Kontena.pastel.yellow('/ master ls')}"

      def execute
        if args[1] && session
          old_context = context.to_a.clone
          context.top
          session.run_command(args[1..-1].join(' '))
          context.concat(old_context) if context.empty?
        else
          context.top
        end
      end
    end
  end
end
