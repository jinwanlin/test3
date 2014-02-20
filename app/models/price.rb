# encoding: utf-8
class Price < ActiveRecord::Base
  attr_accessible :product_id, :product, :actual_cost, :forecast_cost, :date
  # default_scope :order => 'date DESC'
  
  belongs_to :product

  def set_tomorrow_forecast_cost
    #10天前的价格不作为依据
    prices = Price.where(product_id: product).where("date < ?", date).limit(4).order('date DESC')
    if prices && prices.size > 0
      total = 0
      prices.each do |price|
        total = total + price.actual_cost
        # p "actual_cost: #{price.actual_cost }"
      end
      # p "total size"
      # p total
      # p prices.size
      # p "forecast_cost: #{formart(total/prices.size)}"
      self.update_attributes(forecast_cost: formart(total/prices.size))
    end
  end
  
  # 更新过去所有预测价
  def self.update_all_forecast_cost
    Product.all.each do |product|
      product.prices.each do |price|
        price.set_tomorrow_forecast_cost
      end
    end
  end
  
  # 更新明日预测价
  def self.update_tomorrow_price
    Product.all.each do |product|
      product.update_attributes cost: product.prices.last.forecast_cost
    end
  end
  
  def formart(money)
    (money * 100).round / 100.0
  end
  
end
