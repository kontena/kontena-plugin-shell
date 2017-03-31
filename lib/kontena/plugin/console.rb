module Kontena
  module Plugin
    module Console
      def self.commands
        @commands ||= {}
      end

      def self.command(name)
        commands[name]
      end
    end
  end
end

require 'kontena/plugin/console/version'
require 'kontena/plugin/console/session'
