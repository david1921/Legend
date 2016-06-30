require 'legend/converter'
require 'legend/models/demographics'

module Legend
  module Converters
    class Demographics < Converter
      URL = %r(/GetPatientDemographics\.svc/rest/)

      def to_object
        Models::Demographics.new(
          patient_id: data.patID,
          medical_record_number: data.mrn,
          name: data.name,
          given_name: data.ptNameFirst,
          middle_initial: data.ptNameMI,
          family_name: data.ptNameLast,
          date_of_birth: data.dob,
          sex: normalize_sex(data.sex),
          insurance: data.insurance,
        )
      end

    private

      def normalize_sex(sex)
        case sex
          when 'M' then :male
          when 'F' then :female
          else raise ArgumentError.new("Unknown sex: #{sex}")
        end
      end
    end
  end
end
