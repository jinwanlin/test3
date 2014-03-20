# product_types = ['Vegetable', 'Fruit', 'Meat', 'Fish', 'Agri']

product_types = ['Vegetable', 'Fruit', 'Meat', 'Fish', 'Agri']

json.array! product_types do |type|
  json.type type
  json.type_ Product.type_ type
  json.classifies type.constantize::CLASSIFY.to_a
end
