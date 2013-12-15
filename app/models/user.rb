# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :county, :house, :latitude, :longitude, :name, :password, :phone, :street, :string, :towns, :validate_code, :token
  
  validates :phone, :presence => true, uniqueness: true
  

  before_update :change_password
  
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
