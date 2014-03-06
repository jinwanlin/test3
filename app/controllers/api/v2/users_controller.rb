# encoding: utf-8
module Api
  module V2
    class UsersController < Api::BaseController
      before_filter :find_user_by_phone, only: [:sign_up, :sign_in, :get_sign_up_validate_code, :send_validate_code, :update_password]
      
      def has_validate_code
        
      end
      
      # 注册
      def sign_up
        if @user
          @message = "手机号已被注册"
          @user = nil
        else
          @user = User.create(phone: params[:user][:phone])
          @user.password = password_md5(@user.id, params[:user][:password])
          @user.state = "unaudited"
          @user.save
          
          Predict.a @user
        end
      end
      
      # 验证校验码
      def get_sign_up_validate_code
        unless @user
          @validate_code = rand(1000..9999)
          # SMS.send(params[:user][:phone], "注册校验码：#{@validate_code}")
        end
      end
      
      
      # 验证校验码
      def send_validate_code
        if @user
          @validate_code = rand(1000..9999)
          # SMS.send(params[:user][:phone], "注册校验码：#{@validate_code}")
        end
      end
      
      
      # 登陆
      def sign_in
        if @user
          if @user.password == password_md5(@user.id, params[:user][:password])
            @current_user = @user
            cookies.permanent[:token] = @user.token
            @message = "登陆成功！"
          else
            @message = "密码错误！"
            @user = nil
          end
        else
          @message = "手机号未注册！"
        end
      end
      
      def show
        @user = User.find(params[:id])
      end
      
      def update_password
        if @user
          @user.update_attributes password: password_md5(@user.id, params[:user][:password])
        end
      end
      
      private
      def find_user_by_phone
        @user = User.where(phone: params[:user][:phone]).first
      end
      


    end
  end
  
end