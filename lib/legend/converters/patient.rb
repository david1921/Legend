require 'legend/converter'
require 'legend/models/patient'

module Legend
  module Converters
    class Patients < Converter
      URL = %r(/PatientAuthentication\.svc/rest/)

      TIME_FORMAT = '%m/%d/%Y %l:%M%p'

      def to_object
        Models::Patient.new(
          patient_id: data.patID,
          medical_record_number: data.mrn,
          given_name: data.ptNameFirst,
          middle_initial: data.ptNameMI,
          family_name: data.ptNameLast,
          suffix: data.suffix,
          title: data.title,
          date_of_birth: data.dob,
          sex: normalize_sex(data.sex),
          appointments: build_appointments(data.Appointment),
        )
      end

    private

      def build_appointments(appointments)
        appointments.collect { |appointment| build_appointment(appointment) }
      end

      def build_appointment(appointment)
        Models::Patient::Appointment.new(
          csn: appointment.csn,
          date: appointment.apptDate,
          time: parse_time(appointment.apptDate, appointment.apptTime),
          department: appointment.apptDepartment,
          status: appointment.apptStatus,
          type: appointment.apptType,
        )
      end

      def normalize_sex(sex)
        case sex
          when 'M' then :male
          when 'F' then :female
          else raise ArgumentError.new("Unknown sex: #{sex}")
        end
      end

      def parse_time(date, time)
        Time.strptime("#{date} #{time}", TIME_FORMAT) if date && time
      end
    end
  end
end
