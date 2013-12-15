# encoding: utf-8
module ApplicationHelper
  
  def price_format(price)
    sprintf('%.2f', price) if price
  end
  
  def current_user
    @current_user ||= User.find_by_token cookies[:token]
  end

end
