module Api
  module V2
    class OrdersController < Api::BaseController
      
      def list
        @user = User.find(params[:user][:id])
        if @user
          @orders = Order.where(user_id: @user.id).order("id DESC")
        end
      end
      
      def show
        @order = Order.find(params[:id]) if params[:id].present?
      end
      
      
    end
  end
end