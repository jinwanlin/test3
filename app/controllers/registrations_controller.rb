# encoding: utf-8
class RegistrationsController < ApplicationController
  before_filter :find_user, only: [:validate_code, :validate, :new_password, :password]
  
  # 初始化注册
  def sign_up
    
  end
  
  # 注册
  def create
    if params[:user][:phone].present?
      @user = User.where(phone: params[:user][:phone]).first
      if @user.nil?
        @user = User.new params[:user]
        @user.state = "pending"
      elsif @user.state != "pending" # 已被注册
        @user = nil
      end
    end
    
    if @user
      if Settings.has_validate_code
        @user.validate_code = rand(1000..9999) 
        SMS.send(@user.phone, "注册校验码：#{@user.validate_code}")
      end
      @user.save
    end

    respond_to do |format|
      if @user
        format.html {
          if Settings.has_validate_code
            redirect_to validate_code_registration_url(@user)
          else
            @user.update_attributes password: password_md5(@user.id, params[:user][:password])
            @user.audite
            sign_in(@user)
            redirect_to products_path
          end
        }
        format.json
      else
        flash[:error] = "手机号已注册过，请登录或找回密码。" 
        format.html { render "sign_up" }
        format.json
      end
    end
  end
  
  # 校验码页面
  def validate_code
    
  end
  
  # 校验
  def validate
    respond_to do |format|
      if @user.validate_code == params[:validate_code]
        @user.update_attributes validate_code: nil
        flash[:error] = "验证成功。" 
        format.html { render "password_new" }
        format.json
      else
        flash[:error] = "验证码错误。" 
        format.html { render "validate_code" }
        format.json
      end
    end
  end
  
  
  # 设置密码页面
  def password_new
    
  end
  
  # 设置密码
  def password
    @user.update_attributes password: password_md5(@user.id, params[:user][:password])
    @user.audite
    sign_in(@user)
    
    respond_to do |format|
      format.html { redirect_to products_path }
      format.json { render json: @user }
    end
  end
  
  private
  
  def find_user
    @user = User.find(params[:id])
  end

end
