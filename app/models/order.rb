class Order < ActiveRecord::Base
  attr_accessible :product_id, :order_amount, :sn, :sum, :cost, :state
  
  has_many :order_items, dependent: :destroy
  belongs_to :user
  
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
  def total_amount
    total = 0.0
    order_items.each do |item|
      amount = item.ship_amount || item.order_amount
      total += amount * item.price if amount
    end
    (total * 100).round / 100.0
  end
  
  # 订单成本
  def total_cost
    total = 0.0
    order_items.each do |item|
      amount = item.ship_amount || item.order_amount
      total += amount * item.cost if amount
    end
    (total * 100).round / 100.0
  end

  private
  def generate_order_no
    begin
      self.sn = Time.new.strftime("%m%d")+(0...4).map{ ('0'..'9').to_a[rand(10)] }.join
    end while Order.find_by_sn(self.sn)
  end  
end
