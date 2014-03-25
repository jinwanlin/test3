# encoding: utf-8
class Vegetable < Product
  
  # CLASSIFY = ["叶菜类", "根茎类", "瓜果类", "豆荚类", "葱姜蒜", "菌类", "水生菜类"]
  CLASSIFY = {"leaf" => "叶菜类", 
              "rhizome" => "根茎类", 
              "melon_and_fruit" => "瓜果类", 
              "beans" => "豆荚类", 
              "ginger_garlic" => "葱姜蒜", 
              "mushroom" => "菌类", 
              "water_lettuce" => "水生菜类"}
  
  def self.model_name
    Product.model_name
  end

  def self.classify_index key
    i = 0
    CLASSIFY.to_a.each_with_index do |classify, index|
      if classify[0] == key
        i = index+1
        break
      end
    end
    return i
  end
  
end