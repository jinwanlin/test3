json.status 0
json.message @message
p @message

json.partial! "user", user: @user

