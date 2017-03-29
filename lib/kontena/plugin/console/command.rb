require 'kontena/plugin/console/helpers/tokenize'

module Kontena::Plugin
  module Console
    class Command

      attr_reader :context, :args

      def self.commands
        @commands ||= {}
      end

      def self.command(name)
        Array(name).each { |name| Kontena::Plugin::Console::Command.commands[name] = self }
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

      def initialize(context = nil, args = nil)
        @context = context
        @args = Array(args)
      end

      def run
        execute
      rescue ArgumentError => ex
        puts Kontena.pastel.red("ERROR: " + ex.message)
        puts Kontena.pastel.green(ex.backtrace.join("\n  ")) if ENV["DEBUG"]
      end
    end
  end
end

Dir[File.expand_path('../commands/**/*.rb', __FILE__)].each { |file| require file }
