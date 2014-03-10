module Api
  module V2
    class ProductsController < Api::BaseController
      
      def list
        @user = User.find(params[:user][:id])
        if @user
          # @products = Product.order(:id)
          # @products = @products.where(type: params[:type]) if params[:type].present?
          
          @predicts = find_predicts(@user)
          if @predicts.empty?
            Predict.a @user
            @predicts = find_predicts(@user)
          end
          
        end
        
      end
      
      
      def find_predicts(user)
        @predicts = Predict.order(:order_times)
        @predicts = @predicts.where(user_id: user).where(date: Date.today)
        @predicts = @predicts.joins(:product).where("products.type = ?", params[:type]) if params[:type].present?
      end
      
    end
  end
end