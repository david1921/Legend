require 'bigdecimal'
require 'virtus'

module Legend
  module Coercions
    # Accounts for numeric values like "<16.4".
    class EpicDecimal < Virtus::Attribute
      NUMERIC = /^[<>]?(?<value>[\d.]+)$/

      def coerce(value)
        case value
          when NUMERIC then BigDecimal.new($~[:value])
          else super
        end
      end
    end
  end
end
