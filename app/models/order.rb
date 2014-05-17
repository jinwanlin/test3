# encoding: utf-8
class Order < ActiveRecord::Base
  attr_accessible :product_id, :order_amount, :sn, :sum, :cost, :state, :user_id, :delivery_date, :ship_amount_total
  
  has_many :order_items, dependent: :destroy
  belongs_to :user
  has_many :ships, dependent: :destroy
  
  before_create :generate_order_no
  after_destroy :destroy_order
  
  
  STATES = {"pending" => '待提交', "confirmed" => '待打印订单', "shiping" => '待打印出库单', "baled" => '待装车', "truck" => '配送中', "signed" => "已送达", "done" => '交易成功', "canceled" => '已取消'}
  # pending/confirmed/shiping/baled/truck/signed/done/canceled
  state_machine initial: :pending do
    
    before_transition [:signed] => :done, do: :do_done
    before_transition [:confirmed] => :shiping, do: :do_print_order
    before_transition [:shiping] => :baled, do: :do_print_ship
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
  
  def self.profit_sum
    sum = 0
    Order.all.each do |order|
      sum = sum + order.profit
    end
    p "总利润：#{sum}"
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
    sum_ = state_index<3 ? order_sum : ship_sum
    sum_ - cost
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
  
  
  def state_index
    Order::STATES.to_a.each_with_index do |s, index|
      return index if s[0] == state
    end
  end
  
  def reset_cost
    ship_amount_total = 0
    order_items.each do |order_item|
      order_item.reset_cost
      ship_amount_total = ship_amount_total + order_item.ship_amount
    end
    self.update_attributes ship_amount_total: ship_amount_total
  end
  
  # 测试新价格在老订单上获取的利润
  def new_price
    total = 0
    ship_amount_total = 0
    order_items.each do |order_item|
      total = total + order_item.ship_amount * (order_item.product.sales_price - order_item.product.cost)
      ship_amount_total = ship_amount_total + order_item.ship_amount
    end
    p "毛利：#{total}"
    p "毛利率：#{total / ship_sum}"
    
    p "出货总重量：#{ship_amount_total}"
    p "平均每斤利润：#{total/ship_amount_total}"
    nil
  end
  
  private
  def generate_order_no
    begin
      self.sn = (0...6).map{ ('0'..'9').to_a[rand(10)] }.join
    end while Order.find_by_sn(self.sn)
  end  
  
  def do_done
    Pay.create order: self, payer: user, operator: nil, amount: -1*ship_sum
    OrderCount.count(self)
  end
  
  def do_print_order
    content = "{message:'订单#{sn}已发货', state: 'shiping', order_no: '#{sn}', order_id: '#{id}'}"
    
    begin
    Push.new.push_msg(user.baidu_user_id, 0, content)
    rescue
      # 推送失败
    end
  
    Predict.where(user_id: user).update_all order_amount: 0
    Predict.update_user user
  end
  
  def do_print_ship
    ship_amount_total = 0
    order_items.each do |order_item|
      ship_amount_total = ship_amount_total + order_item.ship_amount
    end
    
    self.update_attributes delivery_date: Date.today, ship_amount_total: ship_amount_total
  end
  
  def do_cancel
    Predict.where(user_id: user).update_all order_amount: 0
    Predict.update_user user
  end
  
  def formart(money)
    (money * 100).round / 100.0
  end
  
  def destroy_order
    Predict.where(user_id: user).update_all order_amount: 0
    Predict.update_user user
  end

end

