# encoding: utf-8
class Payment < ActiveRecord::Base
  
  belongs_to :payer, class_name: 'User'
  belongs_to :operator, class_name: 'User'
  belongs_to :order
  
  attr_accessible :payer, :payer_id, :operator, :operator_id, :amount, :overage, :desc, :order, :order_id
  
  before_save :update_overage
  
  def update_overage
    self.overage = payer.overage + amount 
  end
  
  def type_
    case self.type
      when "Pay" then "付款"
      when "Recharge" then "充值"
      when "Refund" then "退款"
    end
  end

  def desc
    case self.type
      when "Pay" then "订单号：#{order.sn}"
      when "Recharge" then "收款人：#{operator.name}"
      when "Refund" then "订单号：#{order.sn}"
    end
  end
  
end
