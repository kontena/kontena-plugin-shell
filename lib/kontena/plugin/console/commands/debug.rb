module Kontena::Plugin
  module Console
    class DebugCommand < Command
      command 'debug'
      description 'Toggle debug output'
      help 'Use debug on/off to toggle debug output.'

      completions 'on', 'off'

      def execute
        case args[1]
        when 'true', 'on', '1'
          ENV['DEBUG'] = 'true'
        when 'api'
          ENV['DEBUG'] = 'api'
        when 'off', 'false', '0'
          ENV.delete('DEBUG')
        when NilClass
          # do nothing
        else
          puts Kontena.pastel.red("Unknown argument '#{args[1]}'")
        end
        puts "Debug #{Kontena.pastel.send(*ENV['DEBUG'] ? [:green, 'on'] : [:red, 'off'])}"
      end
    end
  end
end
