require 'legend/converter'
require 'legend/models/bmi'

module Legend
  module Converters
    class Bmi < Converter
      URL = %r(/GetVitals\.svc/rest/)

      def to_object
        data.bmi.collect.with_index do |bmi,index|
        Models::EncounterNote.new(
          bmi: bmi,
          bmi_date: data.bmiDt[index]
        )
      end

       end
    end
