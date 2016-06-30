require 'legend/model'

module Legend
  module Models
    class Vital < Model
      class Reading < Model
        attribute :date, Coercions::EpicDate
        attribute :value, Decimal
      end

      attribute :name, String
      attribute :readings, Array[Reading]
    end
  end
end
