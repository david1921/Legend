require 'legend/converter'
require 'legend/models/diagnosis'

module Legend
  module Converters
    class ProblemList < Converter
      URL = %r(/GetProblemListDiagnosis\.svc/rest/)

      def to_object
        dates.collect.with_index do |date, index|
          Models::Diagnosis.new(
            date: date,
            icd9: data.PLDxIcd[index],
            name: data.PLDxName[index],
            type: data.PLDxType[index],
          )
        end
      end

    private

      def dates
        data.PLDxDate
      end
    end
  end
end
