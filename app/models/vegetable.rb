# encoding: utf-8
class Vegetable < Product
  
  CLASSIFY = ["叶菜类", "根茎类", "瓜果类", "豆荚类", "葱姜蒜", "菌类", "水生菜类"]
  
  def self.model_name
    Product.model_name
  end
  
end