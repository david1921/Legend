require 'virtus'

module Legend
  module Coercions
    class EpicBoolean < Virtus::Attribute
      YES = /yes/i

      def coerce(value)
        case value
          when YES then true
          when true, false then value
          else false
        end
      end
    end
  end
end
