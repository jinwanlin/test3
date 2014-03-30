# json.array! @products do |product|
#   json.id product.id
#   json.sn product.sn #商品编号
#   json.name product.product_name
#   json.type product.type #分类
#   json.amounts product.get_amounts.join(",") #可选重量
#   json.price product.sales_price(@user.level) #售价
#   json.unit "千克"
# end

if @user
  json.state true
  json.last_order_state @user.orders.last.try(:state)
  json.last_order_id    @user.orders.last.try(:id)
  json.search_history_id @search_history ? @search_history.id : ""
  
  json.products @predicts do |predict|
    json.id                   predict.product_id
    json.sn                   predict.product.sn #商品编号
    json.name                 predict.product.product_name

    avatar = "/product/thumb/no_picture.png"
    avatar = predict.product.attachments.first.source.url(:thumb) unless predict.product.attachments.empty?
    json.avatar               avatar

    json.type                 predict.product.type #分类
    json.amounts              predict.product.get_amounts.join(",") #可选重量
    json.price                predict.product.sales_price(@user.level) #售价
    json.average_amount       predict.average_amount #平均每次订购量
    json.order_times          predict.order_times #最近7天订购次数
    json.order_amount         predict.order_amount #今日订单实际订购量
    json.unit                 predict.product.unit
  end
else
  json.state false
end


