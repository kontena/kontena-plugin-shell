describe Kontena::Plugin::Shell::ExitCommand do
  it 'exits cleanly' do
    expect{described_class.new([], []).run}.to raise_error(SystemExit).and output(/Bye/).to_stdout
  end
end
