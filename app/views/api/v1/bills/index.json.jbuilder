json.status 0
json.message @message
p @message

json.now Time.now

json.bills @bills do |bill|
  json.(bill, :id, :amount)
end

