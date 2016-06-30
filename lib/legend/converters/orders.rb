require 'legend/converter'
require 'legend/models/order'

module Legend
  module Converters
    class Orders < Converter
      URL = %r(/GetOrders\.svc/rest/)

      def to_object
        orders.collect do |order|
          Models::Order.new(
            date: order.OrderDt,
            id: order.OrderID,
            name: order.OrderName,
            status: order.OrderStatus,
            type: order.OrderType,
            procedure: build_procedure(order),
            result_date: order.ResultDt,
          )
        end
      end

    private

      def orders
        data.Order
      end

      def build_procedure(order)
        Models::Order::Procedure.new(
          category_code: order.ProcedureCategoryCode,
          category_name: order.ProcedureCategoryName,
          master_number: order.ProcedureMasterNumber,
        )
      end
    end
  end
end
