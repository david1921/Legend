require 'set'

module Legend
  # Abstract class for handling Epic API response data conversion. The logic
  # here is primarily responsible for tracking the defined converters, and
  # determining which converter to use for any given API response.
  class Converter
    class << self
      # Returns true if the converter can handle the given API response data.
      def applies_to?(url)
        url.to_s =~ self::URL
      end

      # Converts the given API response into a domain model.
      def convert(data)
        new(data).to_object
      end

      # Stores a set of registered converters.
      def converters
        @converters ||= Set.new
      end

      # Returns a converter instance for the given API response data.
      def for(url)
        converters
          .detect { |converter| converter.applies_to?(url) }
      end

      # Responsible for registering the defined converters.
      def inherited(converter)
        converters << converter
      end
    end

    def initialize(data)
      self.data = data
    end

  private

    attr_accessor :data
  end
end
