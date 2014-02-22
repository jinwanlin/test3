json.status 0
json.message @message
p @message

json.partial! "order", order: @order
json.orderItems(@order.orderItems) do |order_item|
  json.partial! "order_items/order_item", order_item: order_item
end
