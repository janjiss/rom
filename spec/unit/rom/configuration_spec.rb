require 'spec_helper'

describe ROM::Configuration do
  it 'is configurable via settings hash' do
    configuration = ROM::Configuration.new(:memory, 'something', infer_schema: false)

    expect(configuration.config.gateways.default.infer_schema).to be(false)

    configuration = ROM::Configuration.new(:memory, infer_schema: false)

    expect(configuration.config.gateways.default.infer_schema).to be(false)

    configuration = ROM::Configuration.new(default: [:memory, infer_schema: false])

    expect(configuration.config.gateways.default.infer_schema).to be(false)
  end

  describe '#method_missing' do
    it 'returns a gateway if it is defined' do
      repo = double('repo')
      configuration = ROM::Configuration.new(repo: repo)

      expect(configuration.repo).to be(repo)
    end

    it 'raises error if repo is not defined' do
      configuration = ROM::Configuration.new

      expect { configuration.not_here }.to raise_error(NoMethodError, /not_here/)
    end
  end

  describe '#[]' do
    it 'returns a gateway if it is defined' do
      repo = double('repo')
      configuration = ROM::Configuration.new(repo: repo)

      expect(configuration[:repo]).to be(repo)
    end

    it 'raises error if repo is not defined' do
      configuration = ROM::Configuration.new({})

      expect { configuration[:not_here] }.to raise_error(KeyError, /not_here/)
    end
  end

  describe 'defining components when adapter was not registered' do
    it 'raises error when trying to define a relation' do
      expect {
        Class.new(ROM::Relation[:not_here])
      }.to raise_error(ROM::AdapterNotPresentError, /not_here/)
    end

    it 'raises error when trying to define a command' do
      expect {
        Class.new(ROM::Commands::Create[:not_here])
      }.to raise_error(ROM::AdapterNotPresentError, /not_here/)
    end
  end
end
