module Api
  module V1
    class OrdersController < Api::BaseController
      def index
        @orders = Order.all
      end
      
      
    end
  end
end