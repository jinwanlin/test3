module Api
  module V1
    class ProductsController < Api::BaseController
      
      def index
        # @user = User.find(params[:user][:id])
        # # params[:type] ||= "Vegetable"
        # @products = Product
        # @products = @products.where('updated_at >= ?', DateTime.parse(params[:last_update_at])) if params[:last_update_at].present? && @user.level == params[:user][:level]
        # @products = @products.where(type: params[:type]) if params[:type].present?
        @user = User.first
        @products = Product.all
      end
      
    end
  end
end