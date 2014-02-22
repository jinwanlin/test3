if payment
  json.id             payment.id
  json.operator_name  payment.operator ? payment.operator.name : ""
  json.amount         payment.amount
  json.overage        payment.overage
  json.order_id       payment.order ? payment.order.try(:id) : ""
  json.order_sn       payment.order ? payment.order.try(:sn) : ''
  json.created_at     payment.created_at.strftime("%F %T")
  json.updated_at     payment.updated_at.strftime("%F %T")
end
