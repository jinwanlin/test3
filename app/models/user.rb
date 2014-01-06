# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :county, :house, :latitude, :longitude, :name, :password, :phone, :street, :string, :towns, :validate_code, :token, :state, :desc, :level
  
  validates :phone, :presence => true, uniqueness: true
  
  has_many :orders

  before_update :change_password
  
  validates :phone, :presence => true
  
  
  state_machine initial: :pending do
    #before_transition :pending => :open, do: :do_done
    event :audite do # 注册
      transition :pending => :unaudited
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
  
  private
  def generate_token
    Digest::MD5::hexdigest(id.to_s + password)
  end
  
end
