# encoding: utf-8
# 付款
class Pay < Payment
  attr_accessible :order, :order_id

  validates :amount, :numericality => {:less_than  => 0}
  
  def self.model_name
    Payment.model_name
  end
end
