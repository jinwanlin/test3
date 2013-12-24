class OrderItem < ActiveRecord::Base

  attr_accessible :product_id, :order_amount, :order_id
  
  belongs_to :order
  belongs_to :product
  
end
