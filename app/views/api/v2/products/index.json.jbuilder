json.now Time.now
json.products @products do |product|
  json.id product.id
  json.sn product.sn #商品编号
  json.name product.product_name
  json.type product.type #分类
  json.amounts product.get_amounts.join(",") #可选重量
  json.price product.sales_price(@user.level) #售价
  json.unit "千克"
end