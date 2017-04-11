require 'kontena/plugin/shell/context'
require 'kontena/plugin/shell/command'
require 'kontena/plugin/shell/completer'
require 'shellwords'
require 'readline'

module Kontena::Plugin
  module Shell
    class Session

      attr_reader :context

      def initialize(context)
        @context = Context.new(context)
        read_history
      end

      def history_file
        ENV['KOSH_HISTORY'] || File.join(Dir.home, '.kosh_history')
      end

      def read_history
        File.readlines(history_file).each { |line| Readline::HISTORY.push(line.chomp) } if File.exist?(history_file)
      end

      def run_command(buf)
        tokens = buf.split(/\s(?=(?:[^"]|"[^"]*")*$)/).map(&:strip)
        runner = Shell.command(tokens.first) || Shell.command(context.first) || Kontena::Plugin::Shell::KontenaCommand
        command = runner.new(context, tokens, self)
        old_trap = trap('INT', Proc.new { Thread.main[:command_thread] && Thread.main[:command_thread].kill })
        Thread.main[:command_thread] = Thread.new do
          command.run
        end
        Thread.main[:command_thread].join
        trap('INT', old_trap)
      end

      def run
        puts File.read(__FILE__)[/__END__$(.*)/m, 1]
        puts
        puts pastel.green("Version #{Kontena::Plugin::Shell::VERSION}")
        puts pastel.blue("Enter 'help' to see a list of commands or 'help <command>' to get help on a specific command.")

        stty_save = `stty -g`.chomp rescue nil
        at_exit do
          File.write(history_file, Readline::HISTORY.to_a.uniq.last(100).join("\n"))
          system('stty', stty_save) if stty_save
        end

        Readline.completion_proc = Proc.new do |word|
          line = Readline.line_buffer
          tokens = line.shellsplit
          tokens.pop unless word.empty?

          if context.empty? && tokens.empty?
            completions = Kontena::MainCommand.recognised_subcommands.flat_map(&:names) + Shell.commands.keys
          else
            command = Shell.command(context.first || tokens.first || 'kontena')
            if command
              if command.completions.first.respond_to?(:call)
                completions = command.completions.first.call(context, tokens, word)
              else
                completions = Array(command.completions)
              end
            else
              completions = []
            end
          end

          word.empty? ? completions : completions.select { |c| c.start_with?(word) }
        end

        while buf = Readline.readline(prompt, true)
          if buf.strip.empty?
            Readline::HISTORY.pop
          else
            run_command(buf)
          end
        end
        puts
        puts pastel.green("Bye!")
      end

      def pastel
        Kontena.pastel
      end

      def config
        Kontena::Cli::Config
      end

      def prompt
        "#{master_name}/#{grid_name} #{pastel.yellow(context)} #{caret} "
      end

      def caret
        pastel.white('>')
      end

      def master_name
        config.current_master ? pastel.green(config.current_master.name) : pastel.red('<no master>')
      end

      def grid_name
        config.current_grid ? pastel.green(config.current_grid) : pastel.red('<no grid>')
      end
    end
  end
end
__END__
  [38;5;69m▒▒[38;5;27m\                           [38;5;69m▒▒[38;5;27m\
  [38;5;69m▒▒[38;5;27m |                          [38;5;69m▒▒[38;5;27m |
  [38;5;69m▒▒[38;5;27m |[38;5;69m  ▒▒[38;5;27m\  [38;5;69m▒▒▒▒▒▒[38;5;27m\   [38;5;69m▒▒▒▒▒▒▒[38;5;27m\ [38;5;69m▒▒▒▒▒▒▒[38;5;27m\
  [38;5;69m▒▒[38;5;27m |[38;5;69m ▒▒  [38;5;27m|[38;5;69m▒▒  [38;5;27m__[38;5;69m▒▒[38;5;27m\ [38;5;69m▒▒  [38;5;27m_____|[38;5;69m▒▒  [38;5;27m__[38;5;69m▒▒[38;5;27m\
  [38;5;69m▒▒▒▒▒▒[38;5;27m  / [38;5;69m▒▒ [38;5;27m/  [38;5;69m▒▒ [38;5;27m|\[38;5;69m▒▒▒▒▒▒[38;5;27m\  [38;5;69m▒▒ [38;5;27m|  [38;5;69m▒▒ [38;5;27m|
  [38;5;69m▒▒ [38;5;27m _[38;5;69m▒▒[38;5;27m<  [38;5;69m▒▒ [38;5;27m|  [38;5;69m▒▒ [38;5;27m| \____[38;5;69m▒▒[38;5;27m\ [38;5;69m▒▒ [38;5;27m|  [38;5;69m▒▒ [38;5;27m|
  [38;5;69m▒▒ [38;5;27m| \[38;5;69m▒▒[38;5;27m\ \[38;5;69m▒▒▒▒▒▒[38;5;27m  |[38;5;69m▒▒▒▒▒▒▒  [38;5;27m|[38;5;69m▒▒ [38;5;27m|  [38;5;69m▒▒ [38;5;27m|
  [38;5;27m\__|  \__| \______/ \_______/ \__|  \__|
[38;5;255m    Kontena Shell [38;5;33m(C) [38;5;255mKontena, Inc 2017
