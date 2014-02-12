class Api::BaseController < ApplicationController
  
  # respond_to :json
  # before_filter :authenticate
  # doorkeeper_for :all, :if => lambda { !basic_auth?(request) }
  # before_filter :find_product
  # before_filter :product_log
  # skip_before_filter :verify_authenticity_token
  # 
  # def add_access_policy_conditions(query)
  #   query.where("scope = 'Everyone' OR user_ids LIKE ?", "%,#{current_user.id},%")
  # end
  # 
  # private
  # def authenticate
  #   if basic_auth?(request)
  #     auth_type = request.authorization.split(" ").first
  #     if auth_type == 'Basic'
  #       valid = authenticate_with_http_basic do |u, p|
  #         @user = User.find_for_database_authentication(:email => u) 
  #         @user.valid_password?(p) if @user
  #       end
  # 
  #       if valid
  #         @current_user = @user
  #       else
  #         render :text => "{\"msg\":\"Authenticate failed\"}", :status => :unauthorized 
  #       end
  #     else 
  #       authenticate_or_request_with_http_token do |token, options|
  #         @current_user = User.find_by_authentication_token token
  #       end
  #     end
  #   end
  # end
  # 
  # def find_product
  #   @product ||= Product.find_by_domain request.headers['Sub-Domain'].try(:strip)
  #   render :text => "{\"msg\":\"Domain required\"}", :status => :unauthorized if @current_user.products.where(id: @product).count < 1
  # end
  # 
  # def basic_auth?(request)
  #   request.authorization.present? && ['Basic', 'Token'].include?(request.authorization.split(" ").first)
  # end
  # 
  # def current_user
  #   if doorkeeper_token
  #     @current_user ||= User.find(doorkeeper_token.resource_owner_id)
  #   end
  #   @current_user
  # end
  # 
  # def product_log
  #   return true unless current_user && @product 
  #   return true if @product.log_state != 'on'
  #   ProductLog.create :product_id => @product.id, :user_id => current_user.id, :user_name => current_user.name || current_user.email,
  #                     :request_method => request.method, :request_resource => request.path,
  #                     :from_ip => request.remote_ip, :browser_info => request.env['HTTP_USER_AGENT']
  # end
  
  helper_method :current_user
  
  def current_user
    unless @current_user
      @current_user = User.find_by_token(cookies[:token]) if cookies[:token].present?
    end
    @current_user
  end
  
  
end