class Price < ActiveRecord::Base
  attr_accessible :purchase_price, :selling_price, :product_id, :product, :purchase_low_price, :purchase_heigh_price, :date
  
  belongs_to :product
  
end
