require 'virtus'

module Legend
  module Coercions
    class EpicDate < Virtus::Attribute
      def coerce(value)
        case value
          when String then Date.strptime(value, '%m/%d/%Y')
          when Date then value
        end
      end
    end
  end
end
