# encoding: utf-8
class Price < ActiveRecord::Base
  attr_accessible :product_id, :product, :actual_cost, :forecast_cost, :date, :forecast_cost
  # default_scope :order => 'date DESC'
  
  after_create :set_tomorrow_forecast_cost
  
  belongs_to :product
  
  # 新建price后，更新第二天的预测价
  def set_tomorrow_forecast_cost
    #10天前的价格不作为依据
    prices = Price.where(product_id: self.product).where("date < ?", self.date+1.days).limit(4).order('date DESC')
    if prices && prices.size > 0
      total = 0
      prices.each do |price|
        total = total + price.actual_cost
      end
      self.update_attributes(forecast_cost: formart(total/prices.size))
    end
  end
  
  def formart(money)
    (money * 100).round / 100.0
  end
  
end
