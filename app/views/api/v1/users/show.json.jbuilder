@message = @user ? "" : "没找到用户"
json.status @user ? 0 : -1
json.message @message
p @message

json.partial! "user", user: @user