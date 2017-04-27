require 'kontena/plugin/shell/command'

module Kontena::Plugin
  module Shell
    class EnvCommand < Command
      command 'env'
      description 'Print environment'
      help 'Use "help <command>" to see help for a specific command'
      #completions -> (context, tokens, word) { Kontena::Completer.complete(context.to_a + tokens) }

      def execute
        if args[1] && args[1].include?('=')
          var, val = args[1].split('=', 2)
          ENV[var]=val
          Kontena::Cli::Config.reset_instance
        elsif args[1]
          puts ENV[args[1]]
        else
          puts ENV.map {|k,v| "#{k}=#{v}"}.join("\n")
        end
      end
    end
  end
end

