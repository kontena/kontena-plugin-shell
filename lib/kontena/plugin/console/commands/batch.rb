require 'kontena/plugin/console/commands/batch_do'

module Kontena::Plugin
  module Console
    class BatchCommand < Command

      command 'batch'
      description 'Run/create command batches'
      help -> (context, tokens) {
        if tokens && tokens[2] && subcommands[tokens[2]]
          subcommands[tokens[2]].help
        else
          <<-EOB.gsub(/^\s+/, '')
            To run a series of commands in a batch, use:

            > batch do
            > command
            > command 2
            > end
          EOB
        end
      }

      subcommands [Kontena::Plugin::Console::BatchDoCommand]
      completions *subcommands.keys
    end
  end
end
