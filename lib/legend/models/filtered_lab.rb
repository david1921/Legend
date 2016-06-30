require 'legend/model'

module Legend
  module Models
    class FilteredLab  < Model
      attribute :lab_date_order, String
      attribute :lab_date_result, String
      attribute :lab_name, String
      attribute :lab_value, String
      
    end
  end
end
