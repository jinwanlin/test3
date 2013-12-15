# encoding: utf-8
class SessionsController < ApplicationController
  
  # 登录
  def new
    
  end
  
  # 登录
  def create
    @user = User.find_by_phone params[:user][:phone]
    
    respond_to do |format|
      if @user.password == password_md5(@user.id, params[:user][:password])
        sign_in(@user)
        
        format.html { redirect_to products_path }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new"}
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
