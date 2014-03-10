json.status true
json.message @message
p @message

json.partial! "order", order: @order
json.order_items(@order.order_items) do |order_item|
  json.partial! "/api/v2/order_items/order_item", order_item: order_item
end
