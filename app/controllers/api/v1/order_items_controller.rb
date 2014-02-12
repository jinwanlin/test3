module Api
  module V1
    class OrderItemsController < Api::BaseController
      before_filter :find_order_item, only: [:show]
      before_filter :find_user, only: [:create]
      
      def index
        
      end
      
      def create
        # order
        @order = @user.orders.last
        if @order && (@order.pending? || @order.open?)
          
        else
          @order = @user.orders.create
        end
    
        # product
        if params[:order_item][:product_id].present?
          product = Product.find params[:order_item][:product_id]
        end
    
        # order_item
        @order_item = @order.order_items.where(product_id: product).first
        if @order_item
          @order_item.order_amount = params[:order_item][:order_amount]
        else
          @order_item = @order.order_items.new(params[:order_item])
          @order_item.product = product
          @order_item.price = product.sales_price(@order_item.order.user.level)
          @order_item.cost = product.cost
        end
        @order_item.save
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