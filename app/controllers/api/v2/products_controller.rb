module Api
  module V2
    class ProductsController < Api::BaseController
      
      def list
        @user = User.find(params[:user][:id])
        if @user

          date = Date.today
          date = date-1.days if Time.new.hour < 3 # 凌晨3点前任然显示昨天的价格
          
          # @products = Product.order(:id)
          # @products = @products.where(type: params[:type]) if params[:type].present?
          
          @predicts = find_predicts(@user, date)
          if @predicts.empty?
            Predict.update_user @user
            @predicts = find_predicts(@user, date)
          end
          
          if params[:searchKey].present?
              SearchHistory.where(keywords: params[:searchKey], user_id: @user).delete_all
              @search_history = SearchHistory.create keywords: params[:searchKey], user: @user, has_result: (@predicts.size>0 ? "true" : "false")
          end
        end
        
      end
      
      
      def find_predicts(user, date)
        @predicts = Predict.where(user_id: user).where(date: date)
        @predicts = @predicts.joins(:product).where("products.type = ?", params[:type]) if params[:type].present?
        @predicts = @predicts.joins(:product).where("products.classify = ?", params[:classify]) if params[:classify].present?
        @predicts = @predicts.joins(:product).where("products.name like ?", "%#{params[:searchKey]}%") if params[:searchKey].present?
        @predicts = @predicts.joins(:product).order("order_times DESC").order("products.pinyin")
        @predicts
      end
      
      def types
        
      end
      
    end
  end
end