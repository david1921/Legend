require 'spec_helper'
require 'json'

require 'epic/middleware/mashify'

describe Epic::Middleware::Mashify do
  let(:app) { double('app', call: nil) }
  let(:mash_class) { double(new: nil) }

  subject(:middleware) { described_class.new(app, mash_class: mash_class) }

  describe '#mash_class' do
    it 'has a default value' do
      middleware = described_class.new(app)
      expect(middleware.mash_class).to eq Hashie::Mash
    end
  end

  describe '#parse' do
    let(:body) { double }

    it 'returns the body' do
      return_value = middleware.parse(body)
      expect(return_value).to eq body
    end

    context 'with a hash' do
      let(:body) { {} }
      let(:mashified_body) { double }

      before do
        allow(mash_class).to receive(:new).and_return(mashified_body)
      end

      it 'mashifies the response body' do
        expect(mash_class).to receive(:new).with(body)
        middleware.parse body
      end

      it 'returns the mashified body' do
        return_value = middleware.parse(body)
        expect(return_value).to eq mashified_body
      end
    end

    context 'with an array of hashes' do
      let(:body) { [{ 'one' => 1 }, { 'two' => 2 }] }
      let(:mashified_elements) { 2.times.collect { double } }

      before do
        body.each.with_index do |element, index|
          allow(mash_class)
            .to receive(:new)
            .with(element)
            .and_return(mashified_elements[index])
        end

        allow(middleware).to receive(:parse).and_call_original
      end

      it 'parses each element in the response body' do
        body.each do |element|
          expect(middleware).to receive(:parse).with(element).ordered
        end

        middleware.parse body
      end

      it 'returns the mashified body' do
        return_value = middleware.parse(body)
        expect(return_value).to match_array mashified_elements
      end
    end
  end
end
