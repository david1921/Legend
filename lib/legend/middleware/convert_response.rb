require 'faraday'

require 'legend/converters'

module Legend
  module Middleware
    # Converts the response into a domain model.
    class ConvertResponse < Faraday::Response::Middleware
      dependency do
        require 'legend/converter'
      end

      attr_accessor :converter

      def initialize(app=nil, options={})
        super app
        self.converter = options.fetch(:converter) { Legend::Converter }
      end

      def on_complete(env)
        env.body = convert(env.url, env.body)
      end

    private

      def convert(url, body)
        converter.for(url).convert(body)
      end
    end
  end
end
