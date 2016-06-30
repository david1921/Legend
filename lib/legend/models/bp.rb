 module Legend
   module Models
      class Bp
       attr_accessor :diabp, :sysbp, :date
      
          def initialize diabp, sysbp, date
           @diabp = diabp
           @sysbp = sysbp
           @date = date
         end
     end
   end
end
