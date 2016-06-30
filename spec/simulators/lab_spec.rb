require 'spec_helper'

require 'epic/simulators/lab'

describe Epic::Simulators::Lab do
  describe '.build' do
    it 'does not raise an error' do
      expect { described_class.build }.to_not raise_error
    end
  end
end
