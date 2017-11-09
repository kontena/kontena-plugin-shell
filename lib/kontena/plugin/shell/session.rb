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
        start = Time.now
        tokens = buf.split(/\s(?=(?:[^"]|"[^"]*")*$)/).map(&:strip)
        runner = Shell.command(tokens.first) || Shell.command(context.first) || Kontena::Plugin::Shell::KontenaCommand
        result = runner.new(context, tokens, self).run
        if config_file_modified_since?(start)
          puts ""
          puts pastel.yellow("Config file has been modified, reloading configuration")
          puts ""
          config.reset_instance
        end
        result
      end

      def config_file_modified_since?(time)
        return false unless config.config_file_available?
        return true if File.mtime(config.config_filename) >= time
      end

      def run
        puts File.read(__FILE__)[/__END__$(.*)/m, 1]
        puts "Kontena Shell v#{Kontena::Plugin::Shell::VERSION} (c) 2017 Kontena"
        puts pastel.green("Enter 'help' to see a list of commands or 'help <command>' to get help on a specific command.")

        stty_save = `stty -g`.chomp rescue nil
        at_exit do
          File.write(history_file, Readline::HISTORY.to_a.uniq.last(100).join("\n"))
          system('stty', stty_save) if stty_save
        end

        # Hook stack command kontena.yml content prompting
        require 'kontena/plugin/shell/callbacks/stack_file'

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
        if master_name && master_name.include?('/'.freeze)
          org, name = master_name.split('/')
          "#{pastel.bright_cyan(org)} / #{pastel.cyan(name)} #{pastel.yellow(context)} #{caret} "
        elsif master_name && grid_name
          "#{pastel.bright_cyan(master_name)} / #{pastel.cyan(grid_name)} #{pastel.yellow(context)} #{caret} "
        elsif master_name
          "#{pastel.bright_cyan(master_name)} / #{pastel.red('<no grid>')} #{pastel.yellow(context)} #{caret} "
        else
          if org = ENV['KONTENA_ORGANIZATION']
            "#{pastel.bright_cyan(org)} #{pastel.yellow(context)} #{caret} "
          else
            "#{pastel.yellow(context)} #{caret} "
          end
        end
      end

      def caret
        pastel.white('>')
      end

      def master_name
        config.current_master.name if config.current_master
      end

      def grid_name
        config.current_grid
      end
    end
  end
end
__END__
_               _
| | _____  _ __ | |_ ___ _ __   __ _
| |/ / _ \| '_ \| __/ _ \ '_ \ / _` |
|   < (_) | | | | ||  __/ | | | (_| |
|_|\_\___/|_| |_|\__\___|_| |_|\__,_|
-------------------------------------
