json.status 0
json.message @message
p @message

json.bills @orders do |order|
  json.(order, :id)
end