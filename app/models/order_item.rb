class OrderItem < ActiveRecord::Base

  attr_accessible :product_id, :order_amount, :order_id
  
  belongs_to :order
  belongs_to :product
  

  after_save :update_order_sum, :update_profit_sum
  after_destroy :update_order_sum, :update_profit_sum
  
  private
  
  
  def update_order_sum
    order.update_attributes sum: order.total_amount
  end
  
  # 订单利润
  def update_profit_sum
    order.update_attributes profit: order.total_profit
  end
  
end
