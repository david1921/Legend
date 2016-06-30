require 'legend/models/order'
require 'legend/simulator'

module Legend
  module Simulators
    class Order < Simulator
      def initialize
        super(Models::Order) do
          date { Fake.date }
          result_date { Fake.date }

          id { Fake.id }
          name { Fake.phrase.upcase }
          status { Fake.status }

          type {
            [
              'LAB CHEMISTRY',
              'LAB HEMATOLOGY',
              'LAB REFERENCE LABORATORY',
              'CARDIAC EKG',
              'LAB COAGULATION',
              'LAB MICROBIOLOGY',
              'Medications',
              'PR Lab',
              'PR Charge',
              'PR Procedure',
              'External Referral',
              'Internal Referral',
              'RAD XRAY/GENERAL',
              'RAD MAMMOGRAPHY',
            ].sample
          }

          procedure {
            Models::Order::Procedure.new(
              category_code: Fake.number(2).to_s,
              category_name: Fake.phrase(2).upcase,
              master_number: Fake.number(5).to_s,
            )
          }
        end
      end
    end
  end
end
