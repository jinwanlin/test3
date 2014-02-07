if user
  json.user do
    json.id user.id
    json.name user.name
    json.phone user.phone
    json.token user.token
    json.address user.address
    json.latitude user.latitude
    json.longitude user.longitude
    json.state user.state
    json.desc user.desc
  end
end