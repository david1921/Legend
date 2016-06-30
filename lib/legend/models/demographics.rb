require 'legend/model'

module Legend
  module Models
    class Demographics < Model
      attribute :patient_id, String
      attribute :medical_record_number, String

      attribute :name, String
      attribute :given_name, String
      attribute :middle_initial, String
      attribute :family_name, String
      attribute :date_of_birth, Coercions::EpicDate
      attribute :sex, Symbol
      attribute :insurance, String
    end
  end
end
