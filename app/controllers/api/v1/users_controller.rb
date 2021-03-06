# encoding: utf-8
module Api
  module V1
    class UsersController < Api::BaseController
      before_filter :find_user_by_phone, only: [:sign_up, :sign_in, :validate]
      
      # 注册
      def sign_up
        
        unless params[:user][:phone].present?
          return
        end
        @user ||= User.create(phone: params[:user][:phone])
          
        if @user.unvalidate? # 已被注册
          @phone_can_use = true
          
          validate_code = rand(1000..9999)
          code = SMS.send(@user.phone, "注册校验码：#{validate_code}")
          if code > 0
            @user.update_attributes validate_code: validate_code

            @message = "请输入验证码"
            @is_send_validate_code = true
          else
            @is_send_validate_code = false
            @message = "验证码发送失败"
            @@logger ||= Logger.new("#{Rails.root}/log/sms.log")
            @@logger.error SMS::MSG["#{code}"]
          end
        else
          @phone_can_use = false
          @user = nil
          @message = "手机号已被注册"
        end
      end
      
      
      
      
      # 验证校验码
      def validate
        p @user.validate_code
        p params[:user][:validate_code]
        if @user.unvalidate? && @user.validate_code == params[:user][:validate_code]
          @user.validate_code = nil
          @user.state = "unaudited"
          @user.password = password_md5(@user.id, params[:user][:password])
          @user.save
          
          @status = 0 
          @message = "验证成功!" 
        else
          @status = -1
          @message = "验证码错误!" 
        end
      end
      
      
      
      # 登陆
      def sign_in
        @message = "登陆失败！"
        if @user
          p @user.password
          p password_md5(@user.id, params[:user][:password])
          
          if @user.password == password_md5(@user.id, params[:user][:password])
            @current_user = @user
            cookies.permanent[:token] = @user.token
            
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
        @user = User.where(phone: params[:user][:phone]).first
      end

    end
  end
  
end