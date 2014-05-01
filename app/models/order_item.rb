class OrderItem < ActiveRecord::Base

  attr_accessible :product_id, :order_amount, :order_id, :ship_amount, :price, :cost, :cost_sum, :ship_sum
  
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
  
  def reset_cost
    
    # price = Price.where(product_id: product).where("updated_at < ?", this.updated_at).order("id desc").first
    # this.update_attributes cost_sum: (cost * ship_sum)
      str = "#{created_at.year}-#{created_at.month}-#{created_at.day}"
      p str
      date = Date.parse str
      date = date + 1.days
      # p date
      price = Price.where(product_id: product).where("date <= ?", date).order("id").last
      # p price
      if price
        update_attributes cost: price.actual_cost 
      # else
      #   p "========#{id}"
      end
      
      update_attributes cost_sum: (cost * ship_amount)
  end
  
  # def aaaa
  #   
  #   Order.find(98).order_items.each do |item|
  #     order_item = OrderItem.where(order_id: 97).where(product_id: item.product).first
  #     item.update_attributes ship_sum: order_item.ship_sum
  #   end
  #   
  # end
  
  
  def method_name
    Order.find(100).order_items.each do |order_item|
      order_item.update_attributes price: order_item.product.sales_price(9, nil)
    end
  end
  
  
  private
  
  # 订单明细总计
  def update_order_item
    if order.pending? || order.confirmed?
      self.order_sum = formart(order_amount * price)
    elsif order.shiping?
      self.ship_sum = ship_sum_amount
      self.cost_sum = cost_sum_amount
    end
  end
  
  # 订单总计
  def update_order
    # if order.pending? || order.confirmed?
      order.order_sum = order.order_sum_amount
    # elsif order.shiping? || order.open?
      order.ship_sum = order.ship_sum_amount
      order.cost = order.total_cost
      
      order.ship_sum = order.ship_sum_amount
      order.cost = order.cost_sum_amount
    # end
    
    if order.order_sum == 0
      order.delete
    else
      order.save
    end
  end
  

  
  def formart(money)
    (money * 100).round / 100.0
  end
  
end
