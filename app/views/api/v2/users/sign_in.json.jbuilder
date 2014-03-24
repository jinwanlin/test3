json.state @user ? true : false
json.message @message
json.partial! "user", user: @user
p @message