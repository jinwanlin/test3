class Method < ActiveRecord::Base
  
  # 更新过去所有预测价
  def self.update_all_forecast_cost
    Product.all.each do |product|
      product.prices.each do |price|
        price.set_tomorrow_forecast_cost
      end
    end
  end
  
  

  
  
end