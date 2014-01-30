class Order < ActiveRecord::Base
  attr_accessible :product_id, :order_amount, :sn, :sum, :cost, :state
  
  has_many :order_items, dependent: :destroy
  belongs_to :user
  has_many :ships, dependent: :destroy
  
  before_create :generate_order_no
  
  # pending/open/ship/done
  state_machine initial: :pending do
    
    # before_transition [:pending, :confirmed] => :done, do: :do_done
    # before_transition [:open, :confirmed] => :canceled, do: :do_cancel
      
    # state :confirmed do
    #   validate {|order| order.validate_invevntory}
    # end
    
    event :submit do
      transition :pending => :open
    end
    
    event :shipment do
      transition :open => :ship
    end
    
    event :done do
      transition [:ship] => :done
    end
    
    event :cancel do
      transition [:pending, :open, :ship] => :canceled
    end
  end
  

  
  # 订单金额
  def order_sum_amount
    total = 0.0
    order_items.each do |item|
      total += item.order_sum
    end
    (total * 100).round / 100.0
  end
  
  # 出货金额
  def ship_sum_amount
    total = 0.0
    order_items.each do |item|
      total += item.ship_sum 
    end
    (total * 100).round / 100.0
  end
  
  # 订单成本
  def total_cost
    total = 0.0
    order_items.each do |item|
      total += item.cost_sum
    end
    (total * 100).round / 100.0
  end

  # 利润
  def profit
    amount = self.ship? ? ship_sum : order_sum
    formart(ship_sum - cost)
  end
  
  # 交易总额
  def ship_sum_amount
    total = OrderItem.where("order_id = ?", self).sum("ship_sum")
    formart(total)
  end
  
  # 成本总额
  def cost_sum_amount
    total = OrderItem.where("order_id = ?", self).sum("cost_sum")
    formart(total)
  end
  
  private
  def generate_order_no
    begin
      self.sn = (0...6).map{ ('0'..'9').to_a[rand(10)] }.join
    end while Order.find_by_sn(self.sn)
  end  
  
  
  def formart(money)
    (money * 100).round / 100.0
  end
end
