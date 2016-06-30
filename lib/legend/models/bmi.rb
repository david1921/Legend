 module Legend
   module Models
      class Bmi 
       attr_accessor :bmi, :bmi_date
      
          def initialize bmi, bmi_date
          @bmi = bmi
          @bmi_date = bmi_date
          end
     end
   end
end
