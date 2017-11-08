require 'kontena/plugin/shell/session'
require 'kontena/plugin/shell/context'

describe Kontena::Plugin::Shell::Session do
  include CliHelper

  let(:context) { spy(Kontena::Plugin::Shell::Context.new(nil)) }
  let(:subject) { described_class.new(context) }

  it 'runs commands' do
    allow(subject).to receive(:fork_supported?).and_return(false)
    expect(Readline).to receive(:readline).and_return('exit')
    expect{subject.run}.to output(/Bye/).to_stdout.and raise_error(SystemExit)
  end
end
