# encoding: utf-8
# 账单
class Payment < ActiveRecord::Base
  
  belongs_to :payer, class_name: 'User'
  belongs_to :operator, class_name: 'User'
  belongs_to :order
  
  attr_accessible :payer, :payer_id, :operator, :operator_id, :amount, :overage, :desc, :order, :order_id, :type
  
  before_save :update_overage
  
  def update_overage
    self.overage = formart(payer.overage + amount)
  end
  
  def type_
    case self.type
      when "Pay" then "付款"
      when "Recharge" then "充值"
      when "Refund" then "退款"
    end
  end

  def desc_
    p desc
    if desc!=nil && desc!=""
      desc
    else
      case self.type
        when "Pay" then "订单号：#{order.try :sn}"
        when "Recharge" then "收款人：#{operator.name}"
        when "Refund" then "订单号：#{order.try :sn}"
      end
    end
  end
  
  def formart(money)
    (money * 100).round / 100.0
  end
  
end
