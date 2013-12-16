# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def password_md5(user_id, password)
    Digest::MD5::hexdigest(password + user_id.to_s + "food") if password && user_id
  end
  
  def current_user
    @current_user# ||= User.find_by_token cookies[:token]
  end
  
  def sign_in(user)
    @current_user = user
    cookies[:token] = { value: user.token, expires: 1.year.from_now, domain: 'lvh.me' }
  end
  
  private
  def current_user
    @_current_user ||= session[:current_user_id] && User.find_by(id: session[:current_user_id])
  end
  
end
