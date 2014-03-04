# encoding: utf-8
# 订单退款
class Refund < Payment
  # attr_accessible :payer, :payer_id, :operator, :operator_id, :amount, :overage, :desc, :order, :order_id
  
  validates :amount, :numericality => {:greater_than  => 0}
  
  def self.model_name
    Payment.model_name
  end
end
