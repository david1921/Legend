require 'legend/models/diagnosis'
require 'legend/simulator'

module Legend
  module Simulators
    class ProblemList < Simulator
      def initialize
        super(Models::Diagnosis) do
          date { Fake.date }
          icd9 { Fake.icd9 }
          name { Fake.phrase }

          type {
            [
              'Problem List',
              'Immunization',
              'Allergy',
            ].sample
          }
        end
      end
    end
  end
end
