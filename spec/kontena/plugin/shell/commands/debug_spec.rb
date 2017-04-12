describe Kontena::Plugin::Shell::DebugCommand do

  context 'without args' do
    it 'displays the current state of debug when debug is on' do
      expect(ENV).to receive(:[]).with('DEBUG').and_return('true')
      expect{described_class.new([], ['debug']).run}.to output(/Debug.*on/).to_stdout
    end
    it 'displays the current state of debug when debug is off' do
      expect(ENV).to receive(:[]).with('DEBUG').and_return(nil)
      expect{described_class.new([], ['debug']).run}.to output(/Debug.*off/).to_stdout
    end
  end

  context 'enabling' do
    it 'sets debug to true with "true"' do
      expect(ENV).to receive(:[]=).with('DEBUG', 'true').and_return(nil)
      expect{described_class.new([], ['debug', 'true']).run}.to output(/Debug/).to_stdout
    end

    it 'sets debug to true with "1"' do
      expect(ENV).to receive(:[]=).with('DEBUG', 'true').and_return(nil)
      expect{described_class.new([], ['debug', '1']).run}.to output(/Debug/).to_stdout
    end

    it 'sets debug to true with "on"' do
      expect(ENV).to receive(:[]=).with('DEBUG', 'true').and_return(nil)
      expect{described_class.new([], ['debug', 'on']).run}.to output(/Debug/).to_stdout
    end

    it 'sets debug to api with "api"' do
      expect(ENV).to receive(:[]=).with('DEBUG', 'api').and_return(nil)
      expect{described_class.new([], ['debug', 'api']).run}.to output(/Debug/).to_stdout
    end
  end

  context 'disabling' do
    it 'sets debug off with "false"' do
      expect(ENV).to receive(:delete).with('DEBUG').and_return(nil)
      expect{described_class.new([], ['debug', 'false']).run}.to output(/Debug/).to_stdout
    end
    it 'sets debug off with "off"' do
      expect(ENV).to receive(:delete).with('DEBUG').and_return(nil)
      expect{described_class.new([], ['debug', 'off']).run}.to output(/Debug/).to_stdout
    end
    it 'sets debug off with "0"' do
      expect(ENV).to receive(:delete).with('DEBUG').and_return(nil)
      expect{described_class.new([], ['debug', '0']).run}.to output(/Debug/).to_stdout
    end
  end
end
