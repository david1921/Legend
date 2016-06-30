require 'legend/model'

module Legend
  module Models
    class MedicationOrder < Model
      class Klass < Model
        attribute :id, String
        attribute :name, String
      end

      attribute :id, String
      attribute :klass, Klass
      attribute :subklass, Klass
      attribute :name_dose_sig, String
      attribute :metric, String
      attribute :associated_diagnoses, Array[String]
      attribute :order_date, Coercions::EpicDate
      attribute :end_date, Coercions::EpicDate
      attribute :patient_reported, Boolean
    end
  end
end
