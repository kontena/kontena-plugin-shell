module Kontena::Plugin
  module Shell
    class ExitCommand < Command
      command 'exit'
      description 'Quit shell'
      help 'Enter "exit" to quit.'

      completions nil

      CleanExit = Class.new(StandardError)

      def execute
        raise CleanExit
      end
    end
  end
end

