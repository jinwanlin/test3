json.status !@order_item.nil?
json.message @message
p @message

json.partial! "order_item", order_item: @order_item