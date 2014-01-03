class OrderItem < ActiveRecord::Base

  attr_accessible :product_id, :order_amount, :order_id
  
  belongs_to :order
  belongs_to :product
  

  after_save :update_order_sum, :update_cost_sum
  after_destroy :update_order_sum, :update_cost_sum
  
  private
  
  
  def update_order_sum
    order.update_attributes sum: order.total_amount
  end
  
  # 订单成本
  def update_cost_sum
    order.update_attributes cost: order.total_cost
  end
  
end
