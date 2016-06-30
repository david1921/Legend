require 'spec_helper'
require 'virtus'

require 'epic/simulator'

describe Epic::Simulator do
  let(:model) {
    Class.new do
      include Virtus.model
      attribute :value, Integer
    end
  }

  let(:simulator) {
    Epic::Simulator.new(model) do
      value { 42 }
    end
  }

  describe '.build' do
    pending
  end

  describe '.build_list' do
    pending
  end

  describe '#build' do
    it 'returns an instance of the model' do
      expect(simulator.build).to be_a model
    end

    it 'uses the factory definition' do
      instance = simulator.build
      expect(instance.value).to eq 42
    end

    it 'allow values to be overridden' do
      instance = simulator.build(value: 37)
      expect(instance.value).to eq 37
    end

    it 'yields the model' do
      expect { |block| simulator.build({}, &block) }
        .to yield_with_args an_instance_of(model)
    end
  end
end
