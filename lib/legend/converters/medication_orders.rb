require 'legend/converter'
require 'legend/models/medication_order'

module Legend
  module Converters
    class MedicationOrders < Converter
      URL = %r(/GetMedicationOrders\.svc/rest/)

      def to_object
        ids.collect.with_index do |id, index|
          Models::MedicationOrder.new(
            id: id,
            klass: build_klass(
              data.medCl[index] ? data.medCl[index].medClId.first : nil,
              data.medCl[index] ? data.medCl[index].medClName.first : nil,
            ),
            subklass: build_klass(
              data.medSCl[index] ? data.medSCl[index].medSClId.first : nil,
              data.medSCl[index] ? data.medSCl[index].medSClName.first : nil,
            ),
            name_dose_sig: data.medNameDS[index],
            metric: data.Metric[index],
            associated_diagnoses: associated_diagnoses(data.medAsDx[index]),
            order_date: data.medOrderDt[index],
            end_date: data.medEndDt[index],
            patient_reported: data.ptRptMedFlg[index]
          )
        end
      end

    private

      def ids
        data.medId
      end

      def associated_diagnoses(medAsDx)
        medAsDx.AsDx if medAsDx
      end

      def build_klass(id, name)
        Models::MedicationOrder::Klass.new(id: id, name: name)
      end
    end
  end
end
