describe Kontena::Plugin::Shell::HelpCommand do
  it 'displays help for kontena commands' do
    expect{described_class.new([], ['help', 'grid', 'ls']).run}.to output(/Usage.*OPTIONS/m).to_stdout
  end

  it 'displays help for kosh commands' do
    expect{described_class.new([], ['help', 'debug']).run}.to output(/toggle/m).to_stdout
  end

  it 'displays help for current context' do
    expect{described_class.new(Kontena::Plugin::Shell::Context.new('master users'), ['help']).run}.to output(/SUBCOMMAND.*invite.*list.*/m).to_stdout
  end
end
