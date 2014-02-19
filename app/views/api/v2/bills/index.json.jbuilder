json.now Time.now

json.bills @bills do |bill|
  json.(bill, :id, :amount)
end

