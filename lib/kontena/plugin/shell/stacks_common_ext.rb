require 'tempfile'

module Kontena
  module Plugin
    module Shell
      module StacksCommonExt
        def reader_from_yaml(*args)
          if args.first == 'kontena.yml' && !File.exist?('kontena.yml')
            tempfile = Tempfile.new('kontena.yml')
            tempfile.write(Kontena.prompt.multiline("Enter or paste a stack YAML").join)
            tempfile.close
            args[0] = tempfile.path
          end
          reader = super(*args)
          File.unlink(args[0]) if File.exist?(args[0])
          reader
        end
      end
    end
  end
end
