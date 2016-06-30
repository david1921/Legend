require 'legend/model'

module Legend
  module Models
    class PatientData < Model
      attribute :phq2Dt, String
      attribute :phq2Sc, String
      attribute :phq9Dt, String
      attribute :phq9Sc, String
      
    end
  end
end
