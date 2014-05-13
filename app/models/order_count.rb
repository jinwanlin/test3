class OrderCount < ActiveRecord::Base
  attr_accessible :date, :product, :product_id, :product, :amount

  # 重新统计所有订购量
  def self.a
    OrderCount.delete_all
    
    Order.all.each do |order|
      count(order)
    end
  end
  
  def self.count(order)
    order.order_items.each do |order_item|
      delivery_date = order.delivery_date
      
      order_count = OrderCount.where(date: delivery_date).where(product_id: order_item.product).first
      order_count = OrderCount.new(product_id: order_item.product.id, date: delivery_date, amount: 0) unless order_count
      order_count.amount = order_count.amount + order_item.order_amount
      order_count.save
      
    end
  end
  
end
