require 'kontena/main_command'

module Kontena::Plugin
  module Console
    class HelpCommand < Command
      command 'help'
      description 'Show help'
      help 'Use "help <command>" to see help for a specific command'
      #completions -> (context, tokens, word) { Kontena::Completer.complete(context.to_a + tokens) }

      def cmd
        full_line = context + args[1..-1]
        cmd = Console.command(full_line.first) || Console.command('kontena')
      end

      def execute
        if cmd.help.respond_to?(:call)
          help_text = cmd.help.call(context, args[1..-1])
        else
          help_text = cmd.help
        end
        puts help_text

        if cmd.has_subcommands?
          puts
          puts Kontena.pastel.green("Subcommands:")
          cmd.subcommands.each do |name, sc|
            puts sprintf('    %-29s %s', name, sc.description)
          end
          puts
        end

        if args.empty? || (args.size == 1 && args.first == 'help')
          puts Kontena.pastel.green('KOSH commands:')
          Console.commands.each do |name, cmd|
            next if cmd == Kontena::Plugin::Console::KontenaCommand
            puts sprintf('    %-29s %s', name, cmd.description)
          end
        end
      end
    end
  end
end
