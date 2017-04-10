module CliHelper
  def self.included(base)
    base.class_eval do
      let(:client) { double(:client) }
      let(:config) { double(:config) }
#      let(:stdout) { StringIO.new }
#      let(:stderr) { StringIO.new }
#      let(:stdin) { StringIO.new }
#      let(:output) { { stderr: [], stdout: [] } }

      before(:each) do
        allow(Kontena::Client).to receive(:new).and_return(client)
        allow(Kontena::Cli::Config).to receive(:instance).and_return(config)
        allow(config).to receive(:current_master).and_return(
          Kontena::Cli::Config::Server.new(
            name: 'testmaster',
            grid: 'testgrid',
            url: 'https://foo.example.com',
            token: Kontena::Cli::Config::Token.new(
              access_token: 'foo',
              expires_at: 0
            )
          )
        )
        allow(config).to receive(:current_grid).and_return('testgrid')

#        allow(stdout).to receive(:anything).and_call_original
#        allow(stderr).to receive(:anything).and_call_original

#        $stdout = stdout
#        $stderr = stderr

        allow(Dir).to receive(:home).and_return('/tmp/')
      end

      after(:each) do
        RSpec::Mocks.space.proxy_for(File).reset
        RSpec::Mocks.space.proxy_for(Kontena::Client).reset
        RSpec::Mocks.space.proxy_for(Kontena::Cli::Config).reset
#        $stdout = STDOUT
#        $stderr = STDERR
      end
    end
  end
end
