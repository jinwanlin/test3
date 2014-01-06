class OrderItem < ActiveRecord::Base

  attr_accessible :product_id, :order_amount, :order_id, :ship_amount
  
  belongs_to :order
  belongs_to :product
  has_many :ships
  

  before_save :update_order_item
  after_save :update_order
  after_destroy :update_order
  
  def ship_sum_amount
    formart(ship_amount * price)
  end
  
  def cost_sum_amount
    formart(ship_amount * cost)
  end
  
  private
  
  # 订单明细总计
  def update_order_item
    if order.pending? || order.open?
      self.order_sum = formart(order_amount * price)
    elsif order.ship?
      self.ship_sum = ship_sum_amount
      self.cost_sum = cost_sum_amount
    end
  end
  
  # 订单总计
  def update_order
    if order.pending?
      order.order_sum = order.order_sum_amount
    elsif order.ship? || order.open?
      order.ship_sum = order.ship_sum_amount
      order.cost = order.total_cost
      
      
      order.ship_sum = order.ship_sum_amount
      order.cost = order.cost_sum_amount
    end
    order.save
  end
  

  
  def formart(money)
    (money * 100).round / 100.0
  end
  
end
