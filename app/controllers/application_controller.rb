# encoding: utf-8
class ApplicationController < ActionController::Base
  # protect_from_forgery
  
  # before_filter :prepare_for_mobile
    
  def password_md5(user_id, password)
    Digest::MD5::hexdigest(password + user_id.to_s + "food") if password && user_id
  end
  
  def current_user
    unless @current_user
      token = cookies[:token] ? cookies[:token] : params[:token]
      @current_user = User.find_by_token(token) if token.present?
    end
    @current_user
  end
  
  def sign_in(user)
    @current_user = user
    cookies.permanent[:token] = user.token
  end
  
  def login_filter
    unless current_user
      @error_code = 1
      
      respond_to do |format|
        format.html { redirect_to "/sessions/new" }
        format.json { render "/sessions/new.json.jbuilder" }
      end
    end
  end
  
  private
  helper_method :current_user
  
  # def mobile_device?
  #   if session[:mobile_param]
  #     session[:mobile_param] == "1"
  #   else
  #     request.user_agent =~ /Mobile|webOS/
  #   end
  # end
  # 
  # helper_method :mobile_device?
  # 
  # def prepare_for_mobile
  #   session[:mobile_param] = params[:mobile] if params[:mobile]
  #   p request.format 
  #   request.format = :mobile if mobile_device? && request.format!="text/javascript"
  # end
end
