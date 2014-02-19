module Api
  module V2
    class OrdersController < Api::BaseController
      def index
        @orders = Order.all
      end
      
      
    end
  end
end