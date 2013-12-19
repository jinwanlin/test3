json.user do
  json.(User.first, :id, :phone)
end
json.state 400

if @error_code
  json.error_code @error_code
end