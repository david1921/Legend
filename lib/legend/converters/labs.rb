require 'legend/converter'
require 'legend/models/lab'

module Legend
  module Converters
    class Labs < Converter
      URL = %r(/GetAllLabs\.svc/rest/)

      ABNORMAL = /Abnormal/i

      def to_object
        labs.collect { |lab| build_lab(lab) }
      end

    private

      def build_lab(lab)
        Models::Lab.new(
          name: lab.LabName,
          order_date: lab.LabDtOrder,
          collection_date: lab.LabColDate,
          result_date: lab.LabDtResult,
          status: lab.OrdStatus,
          abnormal: parse_abnormal(lab.LabAbnor),
          results: build_results(lab.Results)
        )
      end

      def build_results(results)
        results.collect do |result|
          Models::Lab::Result.new(
            component: result.ComponentName,
            value: result.ComponentValue,
            display_value: result.ComponentValue,
            in_range: result.IsVAlueInRange,
            reference_high: result.ReferenceHigh,
            reference_low: result.ReferenceLow,
            reference_normal: result.ReferenceNormal,
            flag: result.ResultFlag,
          )
        end
      end

      def labs
        data.LabOrder
      end

      def parse_abnormal(value)
        !value.match(ABNORMAL).nil? if value
      end
    end
  end
end
