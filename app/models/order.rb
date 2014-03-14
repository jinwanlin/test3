# encoding: utf-8
class Order < ActiveRecord::Base
  attr_accessible :product_id, :order_amount, :sn, :sum, :cost, :state
  
  has_many :order_items, dependent: :destroy
  belongs_to :user
  has_many :ships, dependent: :destroy
  
  before_create :generate_order_no
  after_destroy :destroy_order
  
  
  
  # [pending] --submit--> [confirmed] --:print_order--> [shiping] --:print_ship--> [baled打包完毕] --:sign--> [signed已签收] ----> done /open/ship/done
  # pending/confirmed/shiping/baled/truck/signed/done/canceled
  state_machine initial: :pending do
    
    before_transition [:signed] => :done, do: :do_done
    before_transition [:confirmed] => :shiping, do: :do_print_order
    before_transition [:pending, :confirmed, :shiping, :baled, :truck, :signed] => :canceled, do: :do_cancel
      
    # state :confirmed do
    #   validate {|order| order.validate_invevntory}
    # end
    
    # 提交订单
    event :submit do
      transition :pending => :confirmed
    end
    
    # 继续购买
    event :continue_buy do
      transition :confirmed => :pending
    end
    
    # 打印订单
    event :print_order do
      transition :confirmed => :shiping
    end
    
    # 打印出货单
    event :print_ship do
      transition :shiping => :baled
    end
    
    # 装车
    event :loading do
      transition :baled => :truck
    end
    
    # 签收
    event :sign do
      transition [:truck] => :signed
    end
    
    # 完工（签收5小时后）
    event :done do
      transition [:signed] => :done
    end
    
    # 取消
    event :cancel do 
      transition [:pending, :confirmed, :shiping, :baled, :truck, :signed] => :canceled
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
    amount = self.baled? ? ship_sum : order_sum
    amount - cost
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
  
  def do_done
    Pay.create order: self, payer: user, operator: nil, amount: -1*ship_sum, summary: "订单号：#{self.id}"
  end
  
  def do_print_order
    content = "{message:'订单#{sn}已发货', state: 'shiping'}"
    Push.new.push_msg(user.baidu_user_id, 0, content)
    
    Predict.where(user_id: user).delete_all
    Predict.a user
  end
  
  def do_cancel
    Predict.where(user_id: user).delete_all
    Predict.a user
  end
  
  def formart(money)
    (money * 100).round / 100.0
  end
  
  def destroy_order
    Predict.a user
  end
end

