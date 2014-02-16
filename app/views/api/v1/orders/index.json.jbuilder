json.state 0

json.bills @orders do |order|
  json.(order, :id)
end