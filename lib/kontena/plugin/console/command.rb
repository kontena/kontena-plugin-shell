module Kontena::Plugin
  module Console
    class Command

      attr_reader :context, :args, :session

      def self.command(name = nil)
        return @command if @command
        Array(name).each { |name| Console.commands[name] = self }
        @command = name
      end

      def self.subcommands(subcommands = nil)
        return @subcommands if @subcommands
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
        @context = context
        @args = Array(args)
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
      rescue Kontena::Plugin::Console::ExitCommand::CleanExit
        puts Kontena.pastel.green("Bye!")
        exit 0
      rescue => ex
        puts Kontena.pastel.red("ERROR: " + ex.message)
        puts Kontena.pastel.green(ex.backtrace.join("\n  ")) if ENV["DEBUG"]
      end
    end

    class SubCommand < Command
      def self.command(name = nil)
        @command ||= name
      end
    end

  end
end

Dir[File.expand_path('../commands/**/*.rb', __FILE__)].each { |file| require file }
