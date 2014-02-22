json.status 0
json.message @message
p @message

json.partial! "order", order: @order
json.orderItems(@order.order_items) do |order_item|
  json.partial! "/api/v2/order_items/order_item", order_item: order_item
end
