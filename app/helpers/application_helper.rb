# encoding: utf-8
module ApplicationHelper
  
  def price_format(price)
    # sprintf('%.2f', price) if price
    sprintf('%.2f', (price * 100).round / 100.0) if price
  end
  
end
