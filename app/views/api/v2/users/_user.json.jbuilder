if user
  json.user do
    json.id user.id
    json.name user.name ? user.name : ""
    json.phone user.phone
    json.token user.token
    json.address user.address
    json.latitude user.latitude
    json.longitude user.longitude
    json.state user.state
    json.level user.level
    json.desc user.desc
  end
end