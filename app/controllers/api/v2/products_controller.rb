module Api
  module V2
    class ProductsController < Api::BaseController
      
      def list
        @user = User.find(params[:user][:id])
        @user = User.first
        if @user
          @products = Product.order(:id)
          @products = @products.where(type: params[:type]) if params[:type].present?
        end
      end
      
    end
  end
end