require 'legend/model'

module Legend
  module Models
    class Encounter < Model
      class Clinic < Model
        attribute :id, String
        attribute :name, String
      end

      class Department < Model
        attribute :id, String
        attribute :name, String
      end

      class Diagnosis < Model
        attribute :icd9, String
        attribute :name, String
      end

      class Provider < Model
        attribute :id, String
        attribute :name, String
      end

      class Type < Model
        attribute :id, String
        attribute :name, String
      end

      attribute :csn, String
      attribute :type, Type

      attribute :date, Coercions::EpicDate
      attribute :appointment_time, Time
      attribute :check_in_time, Time
      attribute :showed, Coercions::EpicBoolean

      attribute :chief_complaint, String
      attribute :reasons_for_visit, Array[String]

      attribute :clinic, Clinic
      attribute :department, Department
      attribute :provider, Provider

      attribute :referral_diagnoses, Array[Diagnosis]
      attribute :diagnoses, Array[Diagnosis]

      attribute :closed, Coercions::EpicBoolean
      attribute :closed_at, Time
      attribute :closed_by_user_id, String
    end
  end
end
