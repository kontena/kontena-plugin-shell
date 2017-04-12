require 'kontena/plugin/shell/context'

describe Kontena::Plugin::Shell::Context do

  let(:subject) { described_class.new(nil) }

  it 'creates an empty context' do
    expect(subject.context).to be_empty
  end

  it 'creates a tokenized context from string' do
    expect(described_class.new('foo "bar baz"').context).to eq(['foo', 'bar baz'])
  end

  it 'creates a tokenized context from an array' do
    expect(described_class.new(['foo', 'bar']).context).to eq(['foo', 'bar'])
  end

  describe '#up' do
    it 'goes up' do
      subject.concat(['foo', 'bar'])
      subject.up
      expect(subject.to_s).to eq 'foo'
    end
  end

  describe '#top' do
    it 'clears the context' do
      subject.concat(['foo', 'bar'])
      subject.top
      expect(subject.to_s).to eq ''
    end
  end

  describe '#concat' do
    it 'adds to the context' do
      subject.concat(['foo', 'bar'])
      expect(subject.to_s).to eq 'foo bar'
    end

    it 'only adds everything up to an option' do
      subject.concat(['foo', 'bar', '--help'])
      expect(subject.to_s).to eq 'foo bar'
    end

    it 'only adds everything up to --' do
      subject.concat(['foo', 'bar', '--', 'bar'])
      expect(subject.to_s).to eq 'foo bar'
    end
  end
end

