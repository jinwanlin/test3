class Fruit < Product
  validates :model, :presence => true
  
  def self.model_name
    Product.model_name
  end
end