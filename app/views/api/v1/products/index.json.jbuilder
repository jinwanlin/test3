json.user do
  json.level @user.level
end

json.now Time.now

json.products @products do |product|
  json.(product, :id, :name)
end