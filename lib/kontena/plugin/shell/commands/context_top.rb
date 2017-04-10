module Kontena::Plugin
  module Shell
    class ContextTopCommand < Command
      command '/'
      description 'Clear context'
      help "Go to top in context.\n\nYou can also directly call other commands without switching context by using for example #{Kontena.pastel.yellow('/ master ls')}"

      def execute
        if args.empty?
          context.top
        else
          Kontena::Plugin::Shell::KontenaCommand.new([], args[1..-1]).run
        end
      end
    end
  end
end
