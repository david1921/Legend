require 'legend/model'

module Legend
  module Models
    class Patient < Model
      class Appointment < Model
        attribute :csn, String

        attribute :date, Coercions::EpicDate
        attribute :time, Time
        attribute :department, String
        attribute :status, String
        attribute :type, String
      end

      attribute :patient_id, String
      attribute :medical_record_number, String

      attribute :given_name, String
      attribute :middle_initial, String
      attribute :family_name, String
      attribute :suffix, String
      attribute :title, String
      attribute :date_of_birth, Coercions::EpicDate
      attribute :sex, Symbol

      attribute :appointments, Array[Appointment]
    end
  end
end
