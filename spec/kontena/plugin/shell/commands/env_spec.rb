require 'kontena/cli/config'

describe Kontena::Plugin::Shell::EnvCommand do
  context 'no args' do
    it 'displays current environment' do
      expect{described_class.new([], ['env']).run}.to output(/[A-Z]+=.+?\n/).to_stdout
    end
  end

  context 'env variable name arg' do
    it 'displays requested environment variable value' do
      expect(ENV).to receive(:[]).with('FOO').and_return("bar")
      expect{described_class.new([], ['env', 'FOO']).run}.to output(/^bar$/m).to_stdout
    end

  end

  context 'setting env variable' do
    it 'sets env variable and reloads config' do
      expect(ENV).to receive(:[]=).with('FOO', 'bar').and_return(true)
      expect(Kontena::Cli::Config).to receive(:reset_instance)
      described_class.new([], ['env', 'FOO=bar']).run
    end
  end
end

