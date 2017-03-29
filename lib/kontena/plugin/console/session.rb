require 'kontena/plugin/console/context'
require 'kontena/plugin/console/command'
require 'kontena/plugin/console/helpers/tokenize'
require 'kontena/plugin/console/completer'
require 'shellwords'

module Kontena::Plugin
  module Console
    class Session

      attr_reader :context, :captures

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

      def start_capturing
        @captures = []
        @capturing = true
      end

      def stop_capturing
        @capturing = false
      end

      def capturing?
        !!@capturing
      end

      def run_command(buf)
        tokens = buf.tokenize
        runner = Command.commands[tokens.first || context.first || 'kontena']
        if runner
          command = runner.new(context, tokens)
          old_trap = trap('INT', Proc.new { Thread.main[:command_thread] && Thread.main[:command_thread].kill })
          Thread.main[:command_thread] = Thread.new do
            command.run
          end
          Thread.main[:command_thread].join
          trap('INT', old_trap)
        else
          puts pastel.red("Unknown command")
        end
      end

      def run
        puts pastel.green(File.read(__FILE__)[/__END__$(.*)/m, 1])
        puts pastel.green("Kontena Shell #{Kontena::Plugin::Console::VERSION} (C) 2017 Kontena, Inc")
        puts
        puts pastel.blue("Enter 'help' to see a list of commands or 'help <command>' to get help on a specific command.")
        stty_save = `stty -g`.chomp rescue nil
        at_exit do
          File.write(history_file, Readline::HISTORY.to_a.uniq.last(100).join("\n"))
          system('stty', stty_save) if stty_save
        end

        Readline.completion_proc = Proc.new do |word|
          line = Readline.line_buffer
          line.extend Kontena::Plugin::Console::Helpers::Tokenize
          tokens = line.tokenize
          tokens.pop unless word.empty?

          if context.empty? && tokens.empty?
            completions = Kontena::MainCommand.recognised_subcommands.flat_map(&:names)
          else
            command = Command.commands[context.first || tokens.first || 'kontena']
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

        captures = []

        while buf = Readline.readline(prompt, true)
          buf.extend Kontena::Plugin::Console::Helpers::Tokenize
          tokens = buf.tokenize
          if capturing?
            if tokens.first == 'end'
              stop_capturing
              captures.each { |c| run_command(c) }
            else
              captures << buf
            end
          elsif tokens.first == 'begin' && !capturing?
            start_capturing
          else
            run_command(buf)
          end
        end
      end

      def pastel
        Kontena.pastel
      end

      def config
        Kontena::Cli::Config
      end

      def prompt
        "#{master_name}/#{grid_name} #{pastel.yellow(context)} " +
          (capturing? ? "#{pastel.red(captures.size)}" : "") +
          "#{caret} "
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

       ,--.  ,----..                      ,--,
   ,--/  /| /   /   \   .--.--.         ,--.'|
,---,': / '/   .     : /  /    '.    ,--,  | :
:   : '/ /.   /   ;.  \  :  /`. / ,---.'|  : '
|   '   ,.   ;   /  ` ;  |  |--`  |   | : _' |
'   |  / ;   |  ; \ ; |  :  ;_    :   : |.'  |
|   ;  ; |   :  | ; | '\  \    `. |   ' '  ; :
:   '   \.   |  ' ' ' : `----.   \'   |  .'. |
|   |    '   ;  \; /  | __ \  \  ||   | :  | '
'   : |.  \   \  ',  / /  /`--'  /'   : |  : ;
|   | '_\.';   :    / '--'.     / |   | '  ,/
'   : |     \   \ .'    `--'---'  ;   : ;--'
;   |,'      `---`                |   ,/
'---'                             '---'
