# encoding: utf-8
# 充值
class Recharge < Payment
  # attr_accessible :payer, :payer_id, :operator, :operator_id, :amount, :overage, :desc, :order, :order_id
  
  validates :amount, :numericality => {:greater_than  => 0}
  
  def self.model_name
    Payment.model_name
  end
end
