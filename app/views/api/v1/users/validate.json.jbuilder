json.state @state
json.message @message

if @state
  json.user do
    json.id @user.id
    json.phone @user.phone
  end
end