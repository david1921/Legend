require 'faraday'

module Legend
  module Middleware
    # Parses JSON responses.
    #
    # Adapted from https://github.com/lostisland/faraday_middleware.
    class ParseJSON < Faraday::Response::Middleware
      dependency do
        require 'json' unless defined?(JSON)
      end

      attr_accessor :parser

      def initialize(app=nil, options={})
        super app
        self.parser = options.fetch(:parser) { JSON }
      end

      def parse(body)
        parser.parse(body)
      end
    end
  end
end
