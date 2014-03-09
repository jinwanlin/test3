if payment
  json.id             payment.id
  json.created_at     payment.created_at.strftime("%F %T")
  json.updated_at     payment.updated_at.strftime("%F %T")
  
  json.type           payment.type
  json.desc           payment.desc ? payment.desc : ""
  
  if payment.instance_of? Pay
    summary = "订单号：#{payment.order.sn}"
  elsif payment.instance_of? Recharge
    summary = "收款人：#{payment.operator.name}"
  end
  
  json.summary        summary
  json.amount         payment.amount
  json.overage        payment.overage
  json.order_id       payment.order ? payment.order.try(:id) : ""
  
end
