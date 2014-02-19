json.status @status
json.message @message
p @message

json.partial! "user", user: @user