require 'kontena/main_command'
require 'kontena/plugin/console/completer'

module Kontena::Plugin
  module Console
    class KontenaCommand < Command

      command ['kontena'] + Kontena::MainCommand.recognised_subcommands.flat_map(&:names)
      description 'Run Kontena-cli command'
      help -> (context, tokens) { new(context, tokens).subcommand_class.help('').gsub(/^(\s+)\[OPTIONS\] SUB/, "\\1 SUB") }
      completions -> (context, tokens, word) { Kontena::Plugin::Console::Completer.complete(context.to_a + tokens) }

      def cmd
        cmd = Kontena::MainCommand.new('')
        cmd.parse(context.to_a)
        cmd
      end

      def execute
        cmd.run(args)
      rescue Clamp::HelpWanted => ex
        unless args.include?('--help') || args.include?('-h')
          context.concat(args)
        end
      rescue SystemExit => ex
        puts Kontena.pastel.red('[Command exited with error]') unless ex.status.zero?
      rescue => ex
        puts Kontena.pastel.red("ERROR: #{ex.message}")
      end

      def subcommand_class
        (context + args).reject { |t| t.start_with?('-') }.inject(Kontena::MainCommand) do |base, token|
          if base.has_subcommands?
            sc = base.recognised_subcommands.find { |sc| sc.names.include?(token) }
            sc ? sc.subcommand_class : base
          else
            base
          end
        end
      end
    end
  end
end

if ENV["KOSH_DISABLED_COMMANDS"]
  ENV["KOSH_DISABLED_COMMANDS"].split(',').each do |command|
    tokens = command.split(' ')
    subcommand = tokens.pop
    kontena = Kontena::Plugin::Console::KontenaCommand.new(Kontena::Plugin::Console::Context.new(tokens))
    found_subcommand = kontena.subcommand_class
    found_subcommand.recognised_subcommands.delete_if { |sc| sc.names.include?(subcommand) }
  end
end
