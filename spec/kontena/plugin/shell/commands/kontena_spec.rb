describe Kontena::Plugin::Shell::KontenaCommand do
  context '#run' do
    it 'should be able to run kontena commands' do
      expect{described_class.new([], ['version', '--cli']).run}.to output(/cli:/).to_stdout
    end

    it 'should not run a shell inside a shell' do
      expect{described_class.new([], ['shell']).run}.to output(/Already/).to_stdout
    end

    it 'should switch context if a command with subcommands is run without args' do
      context = Kontena::Plugin::Shell::Context.new(nil)
      described_class.new(context, ['master', 'user']).run
      expect(context.to_s).to eq 'master user'
    end
  end

  context 'completions' do
    it 'should be able to complete kontena commands' do
      expect(described_class.completions.first.call([], ['master', 'user'], 'l')).to include('invite', 'list')
    end

  end

  context 'help' do
    it 'should be able to get help for kontena commands' do
      expect(described_class.help.call([], ['master', 'user'])).to match(/SUBCOMMAND.*invite.*list/m)
    end
  end
end
