require 'spec_helper'

require 'epic/simulators/problem_list'

describe Epic::Simulators::ProblemList do
  describe '.build' do
    it 'does not raise an error' do
      expect { described_class.build }.to_not raise_error
    end
  end
end
