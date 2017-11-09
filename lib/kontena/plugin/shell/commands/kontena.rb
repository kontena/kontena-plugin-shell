require 'kontena/main_command' unless Kontena.const_defined?(:MainCommand)
require 'kontena/plugin/shell/command'
require 'kontena/plugin/shell/completer'
require 'kontena/plugin/shell/context'

module Kontena::Plugin
  module Shell
    class KontenaCommand < Command

      command ['kontena'] + Kontena::MainCommand.recognised_subcommands.flat_map(&:names)
      description 'Run Kontena-cli command'
      help -> (context, tokens) { new(context, tokens).subcommand_class.help('').gsub(/^(\s+)\[OPTIONS\] SUB/, "\\1 SUB") }
      completions -> (context, tokens, word) { Kontena::Plugin::Shell::Completer.complete(context.to_a + tokens) }

      def cmd
        cmd = Kontena::MainCommand.new('')
        cmdline = context.to_a + args
        cmdline.shift if cmdline.first == 'kontena'
        cmd.parse(cmdline)
        cmd
      end

      def run_threaded
        Kontena.logger.debug { "Running threaded: %p" % cmd }
        old_trap = trap('INT', Proc.new { Thread.main[:command_thread] && Thread.main[:command_thread].kill })
        Thread.main[:command_ex] = nil
        Thread.main[:command_ex_class] = nil
        Thread.main[:command_return] = nil
        Thread.main[:command_thread] = Thread.new do
          begin
            Thread.main[:command_return] = cmd.run([])
          rescue SystemExit => ex
            Thread.main[:command_ex] = ex
          rescue => ex
            Thread.main[:command_ex_class] = ex.class.name
            Thread.main[:command_ex_message] = ex.message
          end
        end
        Thread.main[:command_thread].join
        trap('INT', old_trap)
        if Thread.main[:command_ex]
          raise Thread.main[:command_ex]
        elsif Thread.main[:command_ex_class] == 'Clamp::HelpWanted'
          raise Clamp::HelpWanted, Thread.main[:command_ex_message]
        elsif Thread.main[:command_ex_class]
          raise Thread.main[:command_ex_message]
        else
          Thread.main[:command_return]
        end
      end

      def fork_supported?
        Process.respond_to?(:fork)
      end

      def run_command
        fork_supported? ? run_forked : run_threaded
      end

      def run_forked
        Kontena.logger.debug { "Running forked: %p" % cmd }
        read, write = IO.pipe
        pid = fork do
          response = {}

          Process.setproctitle("kosh-runner")
          begin
            response[:result] = cmd.run([])
          rescue SystemExit => ex
            response[:ex] = ex
          rescue => ex
            response[:ex_class] = ex.class.name
            response[:ex_message] = ex.message
          end
          Marshal.dump(response, write)
        end
        write.close
        trap('INT') {
          begin
            Process.kill('TERM', pid)
          rescue Errno::ESRCH
            raise SignalException, 'SIGINT'
          end
        }
        result_str = read.read
        Process.waitpid(pid)
        exit 1 if result_str.empty?
        result = Marshal.load(result_str)
        raise result[:ex] if result[:ex]
        raise(Clamp::HelpWanted, result[:ex_message]) if result[:ex_class] == "Clamp::HelpWanted"
        raise result[:ex_message] if result[:ex_class]
        result[:result]
      end

      def execute
        if cmd.subcommand_name && cmd.subcommand_name == 'shell'
          puts Kontena.pastel.red("Already running inside KOSH")
        else
          run_command
        end
      rescue Clamp::HelpWanted => ex
        if args.include?('--help') || args.include?('-h')
          puts subcommand_class.help('')
        else
          context.concat(args)
        end
      rescue SystemExit => ex
        puts Kontena.pastel.red('[Command exited with error]') unless ex.status.zero?
      rescue => ex
        puts Kontena.pastel.red("ERROR: #{ex.message}")
      ensure
        Thread.main['spinners'] && Thread.main['spinners'].map(&:kill) && Thread.main['spinners'] = nil
      end

      def subcommand_class
        (context + args).reject { |t| t.start_with?('-') }.inject(Kontena::MainCommand) do |base, token|
          if base.has_subcommands?
            sc = base.recognised_subcommands.find { |sc| sc.names.include?(token) }
            sc ? sc.subcommand_class : base
          else
            base
          end
        end
      end
    end
  end
end

if ENV["KOSH_DISABLED_COMMANDS"]
  ENV["KOSH_DISABLED_COMMANDS"].split(',').each do |command|
    tokens = command.split(' ')
    subcommand = tokens.pop
    kontena = Kontena::Plugin::Shell::KontenaCommand.new(Kontena::Plugin::Shell::Context.new(tokens))
    found_subcommand = kontena.subcommand_class
    found_subcommand.recognised_subcommands.delete_if { |sc| sc.names.include?(subcommand) }
  end
end
