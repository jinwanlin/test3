class Ship < ActiveRecord::Base
  attr_accessible :order_id, :sn
  
  belongs_to :product
  belongs_to :order
  belongs_to :order_item
  

  before_save :format_ship
  after_save :update_order_item
  after_destroy :update_order_item
  
  def update_order_item
    ship_amount = Ship.where("order_id = ?", order).where("order_item_id = ?", order_item).sum("amount")
    if order_item
      order_item.ship_amount = formart(ship_amount)
    
      order_item.ship_sum = order_item.ship_sum_amount
      order_item.cost_sum = order_item.cost_sum_amount
      order_item.save
    end
  end
  
  # 保留一位小数
  def formart(money)
    (money * 10).round / 10.0
  end
  
  def format_ship
    self.amount = formart_2(self.amount)
  end
  
  def formart_2(money)
    (money * 100).round / 100.0
  end
  
end
