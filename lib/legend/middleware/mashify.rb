require 'faraday'

module Legend
  module Middleware
    # Converts parsed response bodies to a Hashie::Mash if they were of Hash
    # or Array type.
    #
    # Adapted from https://github.com/lostisland/faraday_middleware.
    class Mashify < Faraday::Response::Middleware
      dependency 'hashie/mash'

      attr_accessor :mash_class

      def initialize(app=nil, options={})
        super app
        self.mash_class = options.fetch(:mash_class) { ::Hashie::Mash }
      end

      def parse(body)
        case body
        when Hash
          mash_class.new(body)
        when Array
          body.map { |item| parse(item) }
        else
          body
        end
      end
    end
  end
end
