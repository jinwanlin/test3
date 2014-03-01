if order
  json.id order.id
  json.sn order.sn
  json.order_sum order.order_sum
  json.ship_sum order.ship_sum ? order.ship_sum : 0
  json.state order.state
  json.desc order.desc
  json.created_at order.created_at.to_s(:db)
  json.updated_at order.updated_at.to_s(:db)
end
