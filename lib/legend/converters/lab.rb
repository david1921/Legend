require 'legend/converter'
require 'legend/models/filtered_lab'

module Legend
  module Converters
    class Lab < Converter
      URL = %r(/GetLabs\.svc/rest/)

      def to_object
        labs.collect do |lab|
          build_labs (lab)
        end
      end

    private

      def labs
        data.Lab
      end
      
      def build_labs lab
          lab.LabDtOrder.collect.with_index do |lab_date, index|
          Models::FilteredLab.new(
             lab_date_order: lab_date,
             lab_date_result: lab.LabDtResult[index],
             lab_name: lab.LabName[index],
             lab_value: lab.LabValue[index]
          )
          end
      end
    end
  end
end
