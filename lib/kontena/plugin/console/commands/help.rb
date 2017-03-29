require 'kontena/main_command'

module Kontena::Plugin
  module Console
    class HelpCommand < Command
      command ['help']
      description 'Show help'
      help 'Use "help <command>" to see help for a specific command'
      #completions -> (context, tokens, word) { Kontena::Completer.complete(context.to_a + tokens) }

      def cmd
        full_line = context + args[1..-1]
        cmd = Kontena::Plugin::Console::Command.commands[full_line.first || 'kontena']
      end

      def execute
        if cmd.help.respond_to?(:call)
          help_text = cmd.help.call(context, args[1..-1])
        else
          help_text = cmd.help
        end
        puts help_text
        puts
        if args.empty? || (args.size == 1 && args.first == 'help')
          puts Kontena.pastel.green('KOSH commands:')
          Command.commands.each do |name, cmd|
            next if cmd == Kontena::Plugin::Console::KontenaCommand
            puts sprintf('    %-29s %s', name, cmd.description)
          end
        end
      end
    end
  end
end
