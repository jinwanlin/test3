module Api
  module V1
    class ProductsController < Api::BaseController
      
      def list
        @user = User.find(params[:user][:id])
        if @user
          @products = Product
          @products = @products.where(type: params[:type]) if params[:type].present?
        end
      end
      
    end
  end
end