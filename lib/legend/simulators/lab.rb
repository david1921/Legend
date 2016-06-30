require 'legend/models/lab'
require 'legend/simulator'

module Legend
  module Simulators
    class Lab < Simulator
      def initialize
        super(Models::Lab) do
          name { Fake.phrase.upcase }
          order_date { Fake.date }
          collection_date { Fake.date }
          result_date { Fake.date }
          status { Fake.status }
          abnormal { Fake.boolean }

          results {
            [
              Models::Lab::Result.new(
                component: Fake.phrase.upcase,
                value: Fake.decimal
              )
            ]
          }
        end
      end
    end
  end
end
