module Api
  module V1
    class ProductsController < Api::BaseController
      def index
        # params[:type] ||= "Vegetable"
        @products = Product
        @products = @products.where(type: "Vegetable")# if params[:type].present?
        @products = @products.order("created_at")
      end
    end
  end
  
end