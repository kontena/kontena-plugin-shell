require 'kontena/main_command'

module Kontena::Plugin
  module Shell
    class Context

      attr_reader :context

      def initialize(context)
        @context = normalize(context)
      end

      def up
        context.pop
      end

      def top
        context.clear
      end

      def concat(tokens)
        arg_index = tokens.index { |a| a == '--' || a.start_with?('-') } || tokens.size
        context.concat(tokens[0..arg_index-1])
      end

      def <<(token)
        context << token
      end

      def empty?
        context.empty?
      end

      def first
        context.first
      end

      def context=(context)
        @command = nil
        @context = context
      end

      def normalize(context)
        return [] if context.nil?
        context.kind_of?(String) ? context.shellsplit : context
      end

      def to_s
        context.join(' ')
      end

      def to_a
        context
      end

      def +(arr)
        context + Array(arr)
      end
    end
  end
end
