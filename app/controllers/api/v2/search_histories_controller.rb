module Api
  module V2
    class SearchHistoriesController < Api::BaseController
      def list
        @user = User.find(params[:user][:id])
        if @user
            @search_histories = SearchHistory.where(user_id: @user, has_result: 'true')
        end
  
      end
      
      
    end
  end
end


