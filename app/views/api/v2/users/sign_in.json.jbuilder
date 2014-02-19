json.status @user ? 0 : -1
json.message @message
json.partial! "user", user: @user
p @message