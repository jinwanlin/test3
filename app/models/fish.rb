# encoding: utf-8
class Fish < Product
  CLASSIFY = {}
  
  def self.model_name
    Product.model_name
  end
end