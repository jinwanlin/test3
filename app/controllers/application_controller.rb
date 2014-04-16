# encoding: utf-8
class ApplicationController < ActionController::Base
  before_filter :authenticate_user 
  # skip_before_filter :authenticate_user!, only: [:current_user]
  

  def authenticate_user
    current_user
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_session_path, :alert => exception.message
  end
  
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
  
  # def login_filter
  #   unless current_user
  #     @error_code = 1
  #     
  #     respond_to do |format|
  #       format.html { redirect_to "/sessions/new" }
  #       format.json { render "/sessions/new.json.jbuilder" }
  #     end
  #   end
  # end
  
  def add_attachments(object)
    if params[:attachments]
      params[:attachments].each do |attachment|
        object.attachments << Attachment.new(:source => attachment) unless attachment.blank?
      end
    end
  
  end
  
  private
  helper_method :current_user
end
