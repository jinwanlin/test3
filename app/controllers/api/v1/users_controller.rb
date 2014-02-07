module Api
  module V1
    class UsersController < Api::BaseController
      def sign_up
        if params[:user][:phone].present?
          @user = User.find_by_phone(params[:user][:phone])
          if @user.nil?
            @user = User.new params[:user]
            @user.state = "pending"
          elsif @user.state != "pending" # 已被注册
            @user = nil
          end
        end
        
        if @user
          if Settings.has_validate_code
            @user.validate_code = rand(9999) 
            SMS.send(@user.phone, "注册校验码：#{@user.validate_code}")
          end
          @user.save
        end
      end
    end
  end
  
end