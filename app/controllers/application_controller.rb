# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def password_md5(user_id, password)
    Digest::MD5::hexdigest(password + user_id.to_s + "food") if password && user_id
  end
  
  def current_user
    @current_user ||= User.find_by_token(cookies[:token] ? cookies[:token] : params[:token] )
  end
  
  def sign_in(user)
    @current_user = user
    cookies.permanent[:token] = user.token
  end
  
  private
  helper_method :current_user
end
