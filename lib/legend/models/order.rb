require 'legend/model'

module Legend
  module Models
    class Order < Model
      class Procedure < Model
        attribute :category_code, String
        attribute :category_name, String
        attribute :master_number, String
      end

      attribute :date, Coercions::EpicDate
      attribute :result_date, Coercions::EpicDate

      attribute :id, String
      attribute :name, String
      attribute :status, String
      attribute :type, String
      attribute :procedure, Procedure
    end
  end
end
