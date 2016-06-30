require 'legend/converter'
require 'legend/models/patient_data'

module Legend
  module Converters
    class PatientData < Converter
      URL = %r(/GetPatientData\.svc/rest/)

      def to_object
        phq.collect.with_index do |phq2dt,index|
        Models::PatientData.new(
          phq2Dt: phq2dt,
          phq2Sc: data.phq2Sc[index],
          phq9Dt: data.phq9Dt[index],
          phq9Sc: data.phq9Sc[index]
        )
      end
      end
      
      def phq
          data.phq2Dt
      end
    end
  end
end
