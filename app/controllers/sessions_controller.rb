# encoding: utf-8
class SessionsController < ApplicationController
  # 登录
  def new
    
  end
  
  # 登录
  def create
    @user = User.where(phone: params[:user][:phone]).first
    
    respond_to do |format|
      if @user.nil?
        flash[:error] = "账号不存在。" 
        
        format.mobile { render action: "new"}
        format.html { render action: "new"}
        format.json
      elsif @user.password == password_md5(@user.id, params[:user][:password])
        sign_in(@user)
        flash[:error] = "登录成功。" 
        
        format.mobile { redirect_to products_path }
        format.html { redirect_to products_path }
        format.json
      else
        flash[:error] = "密码错误。" 
        
        format.mobile { render action: "new"}
        format.html { render action: "new"}
        format.json
      end
    end
  end
   
  # 退出
  def sign_out
    @current_user = nil
    cookies[:token] = nil

    respond_to do |format|
      format.html { redirect_to products_path}
    end
  end
 


end
