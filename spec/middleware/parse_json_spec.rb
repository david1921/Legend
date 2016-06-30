require 'spec_helper'

require 'epic/middleware/parse_json'

describe Epic::Middleware::ParseJSON do
  let(:app) { double('app', call: nil) }
  let(:parser) { double(parse: nil) }

  subject(:middleware) { described_class.new(app, parser: parser) }

  describe '#parser' do
    it 'has a default value' do
      middleware = described_class.new(app)
      expect(middleware.parser).to eq JSON
    end
  end

  describe '#parse' do
    let(:body) { double }
    let(:parsed_body) { double }

    before do
      allow(parser).to receive(:parse).and_return(parsed_body)
    end

    it 'parses the response body' do
      expect(parser).to receive(:parse).with(body)
      middleware.parse body
    end

    it 'returns the parsed response' do
      return_value = middleware.parse(body)
      expect(return_value).to eq parsed_body
    end
  end
end
