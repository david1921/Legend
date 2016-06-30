require 'legend/converter'
require 'legend/models/vital'

module Legend
  module Converters
    class Vitals < Converter
      URL = %r(/GetVitals\.svc/rest/)

      DATE_SUFFIX = 'Dt'

      def to_object
        [
          bmi,
          weight,
          height,
          diastolic_blood_pressure,
          systolic_blood_pressure
        ]
      end

    protected

      def bmi
        build_vital('bmi')
      end

      def weight
        build_vital('wt')
      end

      def height
        build_vital('ht')
      end

      def diastolic_blood_pressure
        build_vital('diabp')
      end

      def systolic_blood_pressure
        build_vital('sysbp')
      end

    private

      def build_reading(value, date)
        Models::Vital::Reading.new(date: date, value: value)
      end

      def build_vital(name)
        Models::Vital.new(name: name, readings: get_readings(name))
      end

      def date_key(name)
        "#{name}#{DATE_SUFFIX}"
      end

      def get_readings(name)
        names = Array(data[name])
        dates = Array(data[date_key(name)])

        names.collect.with_index { |name, index|
          build_reading(name, dates[index])
        }
      end
    end
  end
end
