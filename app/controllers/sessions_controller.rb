# encoding: utf-8
class SessionsController < ApplicationController
  
  # 登录
  def sign_in
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end
  

  # 登录
  def create
    @user = User.where(phone: params[:user][:phone]).first
    if @user.password == password_md5(@user.id, params[:user][:password])
      state = true
    else
      state = false
    end

    respond_to do |format|
      if state
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # 退出
  def destroy
    current_user = nil
    

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end
 


end
