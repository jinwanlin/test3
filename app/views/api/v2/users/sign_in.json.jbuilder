json.state @user true 0 : false
json.message @message
json.partial! "user", user: @user
p @message