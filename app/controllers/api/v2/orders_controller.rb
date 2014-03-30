module Api
  module V2
    class OrdersController < Api::BaseController
      before_filter :find_order, only: [:show, :submit, :continue_buy, :sign, :cancel]
      before_filter :find_user, only: [:list, :auto_make_order]
        
      def list
        if @user
          @orders = Order.where(user_id: @user.id).order("id DESC")
        end
      end
      
      def show
        
      end
      
      def auto_make_order
        @order = @user.orders.create
        
        predicts = Predict.where(user_id: @user).where(date: Date.today)
        predicts.each do |predict|
          order_amount = sprintf('%.0f', predict.average_amount).to_i
          next if order_amount==0
          
          order_item = @order.order_items.new
          order_item.product = predict.product
          order_item.order_amount = order_amount
          order_item.price = predict.product.sales_price(@user.level)
          order_item.save
          
          predict.update_attributes order_amount: order_amount
          
        end
        redirect_to api_v2_order_path(@order)
      end
      
  
      def submit
        @order.submit
        redirect_to api_v2_order_path(@order)
      end
  
      def continue_buy
        @order.continue_buy
        redirect_to api_v2_order_path(@order)
      end
  
      def sign
        @order.sign
        redirect_to api_v2_order_path(@order)
      end

      def cancel
        @order.cancel if @order.pending? || @order.confirmed?
        redirect_to api_v2_order_path(@order)
      end
   
      private
      def find_order
        @order = Order.find(params[:id])
      end
      
      def find_user
        @user = User.find(params[:user][:id])
      end

         
    end
  end
end