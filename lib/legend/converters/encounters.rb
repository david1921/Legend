require 'time'

require 'legend/converter'
require 'legend/models/encounter'

module Legend
  module Converters
    class Encounters < Converter
      URL = %r(/GetEncounter\.svc/rest/)

      TIME_12_HOUR_FORMAT = '%m/%d/%Y %l:%M%p'
      TIME_24_HOUR_FORMAT = '%m/%d/%Y %H:%M:%S'

      def to_object
        csns.collect.with_index do |csn, index|
          Legend::Models::Encounter.new(
            csn: csn,
            type: build_type(data.vtId[index], data.vtName[index]),

            date: data.encDt[index],
            appointment_time: parse_time(data.encDt[index], data.encApptTime[index]),
            check_in_time: parse_time(data.encDt[index], data.encCI[index]),
            showed: data.show[index],

            chief_complaint: data.cc[index],
            reasons_for_visit: reasons_for_visit(data.rsfv[index]),

            clinic: build_clinic(data.clin[index]),
            department: build_department(data.dep[index]),
            provider: build_provider(data.provider[index]),

            referral_diagnoses: build_referral_diagnoses(data.referral[index]),
            diagnoses: build_diagnoses(data.encDx[index]),

            closed: data.EncCloseYN[index],
            closed_at: parse_time(data.EncCloseDate[index], data.EncCloseTime[index], TIME_24_HOUR_FORMAT),
            closed_by_user_id: data.EncCloseUserID[index],
          )
        end
      end

    private

      def build_clinic(clinic)
        return unless clinic

        Models::Encounter::Clinic.new(
          id: clinic.clinID.first,
          name: clinic.clinName.first,
        )
      end

      def build_department(department)
        return unless department

        Models::Encounter::Clinic.new(
          id: department.deptID.first,
          name: department.deptName.first,
        )
      end

      def build_provider(provider)
        return unless provider

        Models::Encounter::Provider.new(
          id: provider.providerID.first,
          name: provider.providerName.first,
        )
      end

      def build_diagnoses(diagnoses)
        return unless diagnoses

        diagnoses.encDxIcd.collect.with_index do |icd9, index|
          build_diagnosis(icd9, diagnoses.encDxName[index])
        end
      end

      def build_diagnosis(icd9, name)
        Models::Encounter::Diagnosis.new(icd9: icd9, name: name)
      end

      def build_referral_diagnoses(referral_diagnoses)
        return unless referral_diagnoses

        referral_diagnoses.RefDxIcd.collect.with_index do |icd9, index|
          build_diagnosis(icd9, referral_diagnoses.RefDxName[index])
        end
      end

      def build_type(id, name)
        Models::Encounter::Type.new(id: id, name: name)
      end

      def csns
        data.csn
      end

      def parse_time(date, time, format=TIME_12_HOUR_FORMAT)
        Time.strptime("#{date} #{time}", format) if date && time
      end

      def reasons_for_visit(reasons)
        reasons.rfv if reasons
      end
    end
  end
end
