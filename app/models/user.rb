# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :county, :house, :latitude, :longitude, :name, :password, :phone, :street, :string, :towns, :validate_code, :token, :state, :desc, :level, :baidu_user_id, :role, :show_product_img
  
  validates :phone, :presence => true, uniqueness: true
  
  has_many :orders
  has_many :payments, foreign_key: 'payer_id', :order => 'id DESC'

  before_update :change_password
  
  validates :phone, :presence => true
  
  before_create :set_default
  
  state_machine initial: :unvalidate do
    #before_transition :pending => :open, do: :do_done
    event :validate do # 注册
      transition :unvalidate => :unaudited
    end
    event :active do # 审核通过
      transition [:unaudited, :freezed] => :actived
    end
    event :frost do # 冻结
      transition :actived => :freezed
    end
  end
  
  
  def address
    "#{county} #{towns} #{street} #{house}"
  end
  
  def change_password
    if password_changed?
      self.token = generate_token
    end
  end
  
  def admin?
    role=="admin" && ["18628405091", "15810845422"].include?(phone)
  end
  
  def state_
    case self.state
      when "unvalidate" then "注册中"
      when "unaudited" then "待审核"
      when "actived" then "正常"
      when "freezed" then "已冻结"
    end
  end
  
  def overage
    payment = payments.first
    payment.nil? ? 0 : payment.overage
  end
  
  def update_predict
    Predict.update_user self 
  end
  
  private
  def generate_token
    Digest::MD5::hexdigest(id.to_s + password)
  end
  
  def set_default
    self.level = 9
  end
  

end
