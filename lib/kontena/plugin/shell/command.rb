module Kontena::Plugin
  module Shell
    class Command

      attr_reader :context, :args, :session

      def self.command(name = nil)
        return @command if instance_variable_defined?(:@command)
        disabled_commands = ENV['KOSH_DISABLED_COMMANDS'].to_s.split(/,/)
        Array(name).each { |name| Shell.commands[name] = self unless disabled_commands.include?(name) }
        @command = name
      end

      def self.subcommands(subcommands = nil)
        return @subcommands if instance_variable_defined?(:@subcommands)
        @subcommands = {}
        Array(subcommands).each do |sc|
          Array(sc.command).each do |name|
            @subcommands[name] = sc
          end
        end
      end

      def self.has_subcommands?
        !subcommands.nil? && !subcommands.empty?
      end

      def has_subcommands?
        self.class.has_subcommands?
      end

      def self.description(text = nil)
        @description ||= text
      end

      def self.help(text = nil)
        @help ||= text
      end

      def self.completions(*completions)
        @completions ||= completions
      end

      def initialize(context = nil, args = nil, session = nil)
        @args = Array(args)
        @context = context
        @session = session
      end

      def run
        if has_subcommands?
          if args[1]
            subcommand = self.class.subcommands[args[1]]
            if subcommand
              subcommand.new(context, args[1..-1], session).run
            else
              puts Kontena.pastel.red("Unknown subcommand")
            end
          else
            context << args[0]
          end
        else
          execute
        end
      rescue Kontena::Plugin::Shell::ExitCommand::CleanExit
        puts Kontena.pastel.green("Bye!")
        exit 0
      rescue => ex
        puts Kontena.pastel.red("ERROR: " + ex.message)
        puts Kontena.pastel.green(ex.backtrace.join("\n  ")) if ENV["DEBUG"]
      end
    end

    # SubCommand is just like a command, except it doesn't register the
    # class to Shell.commands.
    class SubCommand < Command
      def self.command(name = nil)
        @command ||= name
      end
    end

  end
end

Dir[File.expand_path('../commands/**/*.rb', __FILE__)].each { |file| require file }
