module Kontena
  module Plugin
    module Shell
      def self.commands
        @commands ||= {}
      end

      def self.command(name)
        commands[name]
      end
    end
  end
end

require 'kontena/plugin/shell/version'
require 'kontena/plugin/shell/session'
