require 'kontena/plugin/shell/command'
require 'kontena/plugin/shell/context'
require 'kontena/plugin/shell/session'

describe Kontena::Plugin::Shell::Command do
  let(:subject) { Class.new(described_class) }

  it 'can register commands' do
    subject.class_eval do
      command 'foo'
    end
    expect(subject.command).to eq 'foo'
    expect(Kontena::Plugin::Shell.commands['foo']).to eq subject
  end

  it 'can register subcommands' do
    subject.class_eval do
      command 'foo'
      subcommands self
    end
    expect(subject.has_subcommands?).to be_truthy
    expect(subject.subcommands['foo']).to eq subject
  end

  it 'can define a description' do
    subject.class_eval do
      description 'foo'
    end
    expect(subject.description).to eq 'foo'
  end

  it 'can define help text' do
    subject.class_eval do
      help 'foo'
    end
    expect(subject.help).to eq 'foo'
  end

  it 'can define completions' do
    subject.class_eval do
      completions 'foo', 'bar'
    end
    expect(subject.completions).to eq ['foo', 'bar']
  end

  describe '#run' do
    let(:command_class) {
      klass = Class.new(Kontena::Plugin::Shell::Command)
      klass.class_exec do
        subcommand = Class.new(Kontena::Plugin::Shell::SubCommand)
        subcommand.class_exec do
          command 'bar'
          def execute
            args.last
          end
        end
        command 'foo'
        subcommands subcommand
        def execute
        end
      end
      klass
    }

    it 'changes context if subcommands exist but none given' do
      context = Kontena::Plugin::Shell::Context.new(nil)
      command_instance = command_class.new(context, ['foo'])
      command_instance.run
      expect(context.to_s).to eq 'foo'
    end

    it 'runs a subcommand if exists' do
      command_instance = command_class.new([], ['foo', 'bar', 'test'])
      expect(command_instance.run).to eq 'test'
    end

    it 'outputs an error if subcommand is unknown' do
      command_instance = command_class.new([], ['foo', 'bra', 'test'])
      expect{command_instance.run}.to output(/Unknown/).to_stdout
    end

    it 'rescues exceptions and prints out the message' do
      command_class.class_exec do
        instance_variable_set :@subcommands, []
      end
      command_instance = command_class.new([], ['foo'])
      expect(command_instance).to receive(:execute).and_raise(StandardError, 'fooerror')
      expect{command_instance.run}.to output(/fooerror/).to_stdout
    end
  end
end
