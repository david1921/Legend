require 'legend/models/demographics'
require 'legend/simulator'

module Legend
  module Simulators
    class Demographics < Simulator
      def initialize
        super(Models::Demographics) do
          patient_id { |f| Fake.number }
          medical_record_number { Fake.number }

          name { Fake.name }
          date_of_birth { Fake.date(Date.today - 365 * 75) }
          sex { Fake.sex }
          insurance { Fake.company }
        end
      end
    end
  end
end
