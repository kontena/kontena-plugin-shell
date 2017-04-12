describe Kontena::Plugin::Shell::ContextUpCommand do
  it 'goes up in context' do
    context = Kontena::Plugin::Shell::Context.new(['foo', 'bar'])
    described_class.new(context, ['..']).run
    expect(context.to_s).to eq 'foo'
  end
end
