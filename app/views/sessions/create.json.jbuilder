if current_user
  json.user do
    json.(User.first, :id, :phone, :token)
  end
end

json.state current_user ? true : false

if @error_code
  json.error_code @error_code
end
