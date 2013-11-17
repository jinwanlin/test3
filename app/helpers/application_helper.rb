module ApplicationHelper
  
  
  def price_format(price)
    sprintf('%.2f', price) if price
  end
  
end
