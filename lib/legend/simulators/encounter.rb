require 'legend/models/encounter'
require 'legend/simulator'

module Legend
  module Simulators
    class Encounter < Simulator
      def initialize
        super(Models::Encounter) do
          csn { Fake.id }

          type {
            Models::Encounter::Type.new(id: Fake.id, name: Fake.phrase)
          }

          date { Fake.date }
          appointment_time { Fake.time_for_date(date) }
          showed { Fake.boolean }
          check_in_time { showed ? Fake.time_for_date(date) : nil }

          chief_complaint { '' }
          reasons_for_visit { 3.times.collect { Fake.reason_for_visit } }

          clinic {
            Models::Encounter::Clinic.new(id: Fake.id, name: Fake.phrase)
          }

          department {
            Models::Encounter::Department.new(id: Fake.id, name: Fake.phrase)
          }

          provider {
            Models::Encounter::Provider.new(id: Fake.id, name: Fake.name)
          }

          referral_diagnoses {
            [
              Models::Encounter::Diagnosis.new(
                icd9: Fake.icd9,
                name: Fake.phrase
              )
            ]
          }

          diagnoses {
            [
              Models::Encounter::Diagnosis.new(
                icd9: Fake.icd9,
                name: Fake.phrase
              )
            ]
          }

          closed { Fake.boolean }
          closed_at { closed ? Fake.time : nil }
          closed_by_user_id { closed ? Fake.id : nil }
        end
      end
    end
  end
end
