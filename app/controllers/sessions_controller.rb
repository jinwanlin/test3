# encoding: utf-8
class SessionsController < ApplicationController
  skip_before_filter :authenticate_user, only: [:new, :create]
  
  # 登录
  def new
    
  end
  
  # 登录
  def create
    @user = User.where(phone: params[:user][:phone]).first
    
    if @user.nil?
      flash[:error] = "账号不存在。" 
      render action: "new"
    elsif @user.password == password_md5(@user.id, params[:user][:password])
      sign_in(@user)
      flash[:error] = "登录成功。" 
      redirect_to products_path
    else
      flash[:error] = "密码错误。" 
      render action: "new"
    end
  end
   
  # 退出
  def sign_out
    @current_user = nil
    cookies[:token] = nil

    redirect_to products_path
  end
 


end
