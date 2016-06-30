require 'legend/converter'
require 'legend/models/provider'

module Legend
  module Converters
    class Providers < Converter
      URL = %r(/GetProvider\.svc/rest/)

      def to_object
        provider_ids.collect.with_index { |provider_id, index|
          Models::Provider.new(
            id: provider_id,
            no_show_count: data.cntNoShow[index],
            visit_count: data.cntVisit[index],
            last_visit_date: data.lastVisitDate[index],
            name: data.provName[index],
            role: data.provRole[index],
            type: build_type(data.provTyId[index], data.provTyName[index]),
            specialties: build_specialties(data.providerSpecialties[index])
          )
        }
      end

    private

      def provider_ids
        data.provID
      end

      def build_type(id, name)
        Models::Provider::Type.new(
          id: id,
          name: name
        )
      end

      def build_specialties(specialties)
        ids = specialties.provSpecID
        names = specialties.provSpec

        ids.collect.with_index do |id, index|
          build_specialty(id, names[index])
        end
      end

      def build_specialty(id, name)
        Models::Provider::Specialty.new(
          id: id,
          name: name
        )
      end
    end
  end
end
