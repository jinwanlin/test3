# encoding: utf-8
module Api
  module V1
    class UsersController < Api::BaseController
      before_filter :find_user_by_phone, only: [:sign_up, :sign_in, :validate]
      before_filter :find_user_by_id, only: [:set_password, :send_validate_code]
      
      
      # 注册
      def sign_up
        @is_send_validate_code = false
        @phone_can_use = false
        
        if params[:user][:phone].present?
          if @user.nil?
            @user = User.create(phone: params[:user][:phone])
            @phone_can_use = true
          elsif @user.state != "unvalidate" # 已被注册
            @user = nil
          else
            @phone_can_use = true
          end
        end
        
        if @user
          validate_code = rand(1000..9999)
          
          code = SMS.send(@user.phone, "注册校验码：#{validate_code}")
          if code > 0
            @user.validate_code = validate_code
            @user.save
            
            @is_send_validate_code = true
          else
            @@logger ||= Logger.new("#{Rails.root}/log/sms.log")
            @@logger.error SMS::MSG["#{code}"]
          end
          
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
          
          @state = 0 
          @message = "验证成功!" 
        else
          @state = -1
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