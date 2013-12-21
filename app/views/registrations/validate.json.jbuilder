if @user
  json.user do
    json.(@user, :id, :phone, :validate_code)
  end
end

json.state @user ? true : false

if @error_code
  json.error_code @error_code
end
