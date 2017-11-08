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
        if fork_supported?
          execute_with_fork(command)
        else
          execute_with_thread(command)
        end
      end

      def fork_supported?
        !Gem.win_platform?
      end

      def execute_with_thread(command)
        old_trap = trap('INT', Proc.new { Thread.main[:command_thread] && Thread.main[:command_thread].kill })
        Thread.main[:command_thread] = Thread.new do
          command.run
        end
        Thread.main[:command_thread].join
        trap('INT', old_trap)
      end

      def execute_with_fork(command)
        start = Time.now
        pid = fork do
          Process.setproctitle("kosh-runner")
          command.run
        end
        trap('INT') {
          begin
            Process.kill('TERM', pid)
          rescue Errno::ESRCH
            raise SignalException, 'SIGINT'
          end
        }
        Process.waitpid(pid)
        if config_file_modified_since?(start)
          puts ""
          puts pastel.yellow("Config file has been modified, reloading configuration")
          puts ""
          config.reset_instance
        end
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
        "#{master_name}/#{grid_name} #{pastel.yellow(context)} #{caret} "
      end

      def caret
        pastel.white('>')
      end

      def master_name
        config.current_master ? pastel.blue(config.current_master.name) : pastel.red('<no master>')
      end

      def grid_name
        config.current_grid ? pastel.blue(config.current_grid) : pastel.red('<no grid>')
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
