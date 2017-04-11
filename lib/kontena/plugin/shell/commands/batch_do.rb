require 'kontena/plugin/shell/command'

module Kontena::Plugin
  module Shell
    class BatchDoCommand < SubCommand

      command 'do'
      description 'Run a batch of commands'
      help "Example:\n> batch do\n> master users ls\n> master ls\n> end"
      completions nil

      def execute
        if args.size > 1
          lines = args[1..-1].join(' ').split(/(?<!\\);/).map(&:strip)
        else
          lines = []
          while buf = Readline.readline("#{Kontena.pastel.green('..')}#{Kontena.pastel.red('>')} ", true)
            buf.strip!
            break if buf == 'end'
            lines << buf unless buf.empty?
          end
          (lines.size + 1).times { Readline::HISTORY.pop }
          Readline::HISTORY.push "batch do #{lines.join('; ')}"
        end

        lines.each { |line| session.run_command(line) }
      end
    end
  end
end
