require 'legend/model'

module Legend
  module Models
    class Diagnosis < Model
      attribute :date, Coercions::EpicDate
      attribute :icd9, String
      attribute :name, String
      attribute :type, String # "Problem List", "Allergy", "Immunization", etc.
    end
  end
end
