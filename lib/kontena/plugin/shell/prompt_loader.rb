require 'kontena/cli/stacks/yaml/stack_file_loader'

module Kontena
  module Plugin
    module Shell
      class PromptLoader < Kontena::Cli::Stacks::YAML::StackFileLoader
        def self.match?(source, parent = nil)
          source.end_with?('kontena.yml') && !Kontena::Cli::Stacks::YAML::FileLoader.match?(source, parent)
        end

        def read_content
          content = Kontena.prompt.multiline("Enter or paste a stack YAML").join
          raise "Invalid stack YAML" unless YAML.safe_load(content).kind_of?(Hash)
          content
        end

        def origin
          "prompt"
        end

        def registry
          "prompt"
        end
      end
    end
  end
end
