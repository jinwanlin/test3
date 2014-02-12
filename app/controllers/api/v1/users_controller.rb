# encoding: utf-8
module Api
  module V1
    class UsersController < Api::BaseController
      before_filter :find_user_by_phone, only: [:sign_up, :sign_in]
      before_filter :find_user_by_id, only: [:set_password, :validate]
      
      
      # 注册
      def sign_up
        if params[:user][:phone].present?
          if @user.nil?
            @user = User.create(phone: params[:user][:phone])
          elsif @user.state != "unvalidate" # 已被注册
            @user = nil
            @message = "手机号已注册，请登录或找回密码。"
          end
        end
        
        if @user
          @user.password = password_md5(@user.id, params[:user][:password])
          
          if Settings.has_validate_code
            @user.validate_code = rand(1000..9999)
            # SMS.send(@user.phone, "注册校验码：#{@user.validate_code}")
            @message = "请输入短信校验码"
          else
            @user.state = "unaudited"
            @message = "注册成功"
          end
          @user.save
        end
      end
      
      # 验证校验码
      def validate
        if @user.validate_code == params[:user][:validate_code]
          @user.update_attributes validate_code: nil
          @user.validate!
          @state = true 
          @message = "验证成功!" 
        else
          @state = false
          @message = "验证码错误!" 
        end
      end
      
      # # 第一次设置密码，其密码必须为空
      # def set_password
      #   @state = false
      #   unless @user.password
      #     @user.update_attributes password: password_md5(@user.id, params[:user][:password])
      #     @user.audite
      #     @state = true
      #   end
      # end
      
      
      # 登陆
      def sign_in
        @message = "登陆失败！"
        if @user
          if @user.password == password_md5(@user.id, params[:user][:password])
            @current_user = user
            cookies.permanent[:token] = user.token
            
            @message = "登陆成功！"
          else
            @user = nil
          end
        end
      end
      
      def show
        @user = User.find(params[:id])
      end
      
      private
      def find_user_by_phone
        @user = User.find_by_phone(params[:user][:phone])
      end

      def find_user_by_id
        @user = User.find(params[:user][:id])
      end
    end
  end
  
end