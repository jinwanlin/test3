module Api
  module V2
    class OrdersController < Api::BaseController
      def list
        @orders = Order.all
      end
      
      
    end
  end
end