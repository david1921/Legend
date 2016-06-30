require 'legend/model'

module Legend
  module Models
    class Provider < Model
      class Type < Model
        attribute :id, String
        attribute :name, String
      end

      class Specialty < Model
        attribute :id, String
        attribute :name, String
      end

      attribute :no_show_count, Integer
      attribute :visit_count, Integer
      attribute :last_visit_date, Coercions::EpicDate
      attribute :id, String
      attribute :name, String
      attribute :role, String
      attribute :type, Type
      attribute :specialties, Array[Specialty]
    end
  end
end
