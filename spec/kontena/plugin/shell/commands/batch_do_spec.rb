describe Kontena::Plugin::Shell::BatchDoCommand do

  context 'with args' do
    it 'runs a batch of commands' do
      allow(ENV).to receive(:[]=).with('DEBUG', 'true').and_return(nil)
      allow(ENV).to receive(:delete).with('DEBUG').and_return(nil)
      described_class.new([], ['do', 'debug', 'off;', 'debug', 'on'])
    end
  end
end
