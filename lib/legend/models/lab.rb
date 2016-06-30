require 'legend/model'

module Legend
  module Models
    class Lab < Model
      class Result < Model
        attribute :component, String
        attribute :value, Coercions::EpicDecimal # "Non Reactive", neg
        attribute :display_value, String
        attribute :in_range, Coercions::EpicBoolean # Yes
        attribute :reference_high, Decimal
        attribute :reference_low, Decimal # Neg
        attribute :reference_normal, Decimal # <30, >60, "Non Reactive"
        attribute :flag, String # "Abnormal", "High"
      end

      attribute :name, String
      attribute :order_date, Coercions::EpicDate
      attribute :collection_date, Coercions::EpicDate
      attribute :result_date, Coercions::EpicDate
      attribute :status, String # Canceled, Completed, Sent
      attribute :abnormal, Boolean # Abnormal, Normal
      attribute :results, Array[Result]
    end
  end
end
