# encoding: utf-8
class Vegetable < Product
  
  GROUP = {"01" => "根茎类", "02" => "叶菜", "03" => "菌类"}
  
  def self.model_name
    Product.model_name
  end
  
end