require 'spec_helper'

require 'epic/mash'

describe Epic::Mash do
  it { should be_a(Hashie::Mash) }

  describe '#convert_value' do
    context 'with a String with surrounding whitespace' do
      let(:value) { ' 7942 ' }

      it 'strips the value' do
        response = described_class.new(value: value)
        expect(response.value).to eq '7942'
      end
    end

    context 'with an empty String' do
      let(:value) { '' }

      it 'returns nil' do
        response = described_class.new(value: value)
        expect(response.value).to be_nil
      end
    end
  end
end
