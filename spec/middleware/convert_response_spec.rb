require 'spec_helper'

require 'epic/middleware/convert_response'

describe Epic::Middleware::ConvertResponse do
  let(:app) { double('app', call: nil) }

  let(:converter_class) { double(for: converter) }
  let(:converter) { double(convert: nil) }

  subject(:middleware) { described_class.new(app, converter: converter_class) }

  describe '#converter' do
    it 'has a default value' do
      middleware = described_class.new(app)
      expect(middleware.converter).to eq Epic::Converter
    end
  end

  describe '#on_complete' do
    let(:body) { double }
    let(:converted_body) { double }
    let(:url) { double }

    let(:env) { Struct.new(:body, :url).new(body, url) }

    before do
      allow(converter_class).to receive(:for).and_return(converter)
      allow(converter).to receive(:convert).and_return(converted_body)
    end

    it 'determines the converted based on the URL' do
      expect(converter_class).to receive(:for).with(url)
      middleware.on_complete env
    end

    it 'converts the response body' do
      expect(converter).to receive(:convert).with(body)
      middleware.on_complete env
    end

    it 'updates the body with the converted response' do
      expect { middleware.on_complete(env) }
        .to change(env, :body)
        .from(body)
        .to(converted_body)
    end
  end
end
