module Api
  module V2
    class OrderItemsController < Api::BaseController
      before_filter :find_order_item, only: [:show]
      before_filter :find_user, only: [:create]
      
      def index
        
      end
      
      def create
        # order
        @order = @user.orders.last
        if @order && (@order.pending? || @order.confirmed?)
          @order.continue_buy if @order.confirmed?
        else
          @order = @user.orders.create
        end
    
        # product
        if params[:order_item][:product_id].present?
          product = Product.find params[:order_item][:product_id]
        end
        
        predict = Predict.where(user_id: @user).where(date: Date.today).where(product_id: product).first
        predict.update_attributes order_amount: params[:order_item][:order_amount]
    
        # order_item
        @order_item = @order.order_items.where(product_id: product).first
        if @order_item
          p params[:order_item][:order_amount]
          if params[:order_item][:order_amount] == "0"
            @order_item.destroy
          else
            @order_item.order_amount = params[:order_item][:order_amount]
            @order_item.save
          end
        else
          if params[:order_item][:order_amount] != 0
            @order_item = @order.order_items.new(params[:order_item])
            @order_item.product = product
            @order_item.price = product.sales_price(@order_item.order.user.level)
            @order_item.cost = product.cost
            @order_item.save
          end
        end
      end
      
      def show
        
      end
      
      
      private
      def find_order_item
        @order_item = OrderItem.find(params[:id])
      end

      def find_user
        @user = User.find(params[:user][:id])
      end
    end
  end
  
end