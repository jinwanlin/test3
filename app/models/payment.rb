class Payment < ActiveRecord::Base
  default_scope :order => 'id DESC'
  
  belongs_to :payer, class_name: 'User'
  belongs_to :operator, class_name: 'User'
  belongs_to :order
  
  attr_accessible :payer, :payer_id, :operator, :operator_id, :amount, :overage, :desc, :order, :order_id
  
  before_save :update_overage
  
  def update_overage
    self.overage = payer.overage + amount 
  end
  
end
