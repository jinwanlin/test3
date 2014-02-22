module Api
  module V2
    class ProductsController < Api::BaseController
      
      def list
        @user = User.find(params[:user][:id])
        if @user
          # @products = Product.order(:id)
          # @products = @products.where(type: params[:type]) if params[:type].present?
          
          @predicts = Predict.order(:order_times)
          @predicts = @predicts.where(user_id: @user).where(date: Date.today)
          
        end
      end
      
    end
  end
end