describe Kontena::Plugin::Shell::ContextTopCommand do
  it 'goes to top in context' do
    context = Kontena::Plugin::Shell::Context.new(['foo', 'bar'])
    described_class.new(context, ['/']).run
    expect(context.to_s).to eq ''
  end

  it 'runs commands under top context if passed and keeps current context' do
    session = Kontena::Plugin::Shell::Session.new(['foo', 'bar'])
    expect(session).to receive(:run_command).with('dog cat').and_return(true)
    described_class.new(session.context, ['/', 'dog', 'cat'], session).run
    expect(session.context.to_s).to eq 'foo bar'
  end

  it 'runs commands under top context and changes to that context if it changes context' do
    session = Kontena::Plugin::Shell::Session.new(['foo', 'bar'])
    expect(session).to receive(:run_command).with('dog cat') { session.context.context=['dog', 'cat'] }
    described_class.new(session.context, ['/', 'dog', 'cat'], session).run
    expect(session.context.to_s).to eq 'dog cat'
  end
end

