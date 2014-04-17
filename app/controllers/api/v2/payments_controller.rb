module Api
  module V2
    class PaymentsController < Api::BaseController
      
      def list
        @user = User.find(params[:user][:id])
        if @user
          @payments = @user.payments
        end
        
      end
      
    end
  end
end
