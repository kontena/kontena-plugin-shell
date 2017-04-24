require 'tempfile'
module Kontena
  module Plugin
    module Shell
      module Callbacks
        class StackFile < Kontena::Callback

          matches_commands 'stacks install', 'stacks validate', 'stacks upgrade'

          def before
            Kontena::Cli::Stacks::YAML::Reader.class_eval do
              def self.new(*args)
                if args.first == 'kontena.yml' && !File.exist?('kontena.yml')
                  @tempfile = Tempfile.new('kontena.yml')
                  @tempfile.write(Kontena.prompt.multiline("Enter or paste a stack YAML").join)
                  @tempfile.close
                  args[0] = @tempfile.path
                end
                super *args
              end
            end
          end

          def after
            @tempfile.unlink if @tempfile
          end
        end
      end
    end
  end
end
