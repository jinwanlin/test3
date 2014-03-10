@message = @user ? "" : "没找到用户"
json.state @user ? true : false
json.message @message

json.partial! "user", user: @user
p @message