json.state @user ? false : true
json.message @message
p @message

json.partial! "user", user: @user

