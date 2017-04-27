require 'kontena/plugin/shell/command'

module Kontena::Plugin
  module Shell
    class EnvCommand < Command
      command 'env'
      description 'Show or set environment variables'
      help "Use 'env' to display all environment variables.\n" +
           "Use 'env HOME' to display the value of $HOME.\n" +
           "Use 'env KONTENA_URL=https://foo.example.com' to set an environment variable."
      completions -> (context, tokens, word) { ENV.keys.select { |k| k.start_with?(word) } }

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

