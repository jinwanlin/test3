json.state @user ? true : false
json.message @message
p @message

json.partial! "user", user: @user

