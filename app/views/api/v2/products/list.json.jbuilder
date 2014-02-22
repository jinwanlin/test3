# json.array! @products do |product|
#   json.id product.id
#   json.sn product.sn #商品编号
#   json.name product.product_name
#   json.type product.type #分类
#   json.amounts product.get_amounts.join(",") #可选重量
#   json.price product.sales_price(@user.level) #售价
#   json.unit "千克"
# end

json.array! @predicts do |predict|
  json.id                   predict.product_id
  json.sn                   predict.product.sn #商品编号
  json.name                 predict.product.name
  json.type                 predict.product.type #分类
  json.amounts              predict.product.get_amounts.join(",") #可选重量
  json.price                predict.product.sales_price(@user.level) #售价
  json.average_amount       predict.average_amount #平均每次订购量
  json.order_times          predict.order_times #最近7天订购次数
  json.order_amount         predict.order_amount #今日订单实际订购量
  json.unit "千克"
end
