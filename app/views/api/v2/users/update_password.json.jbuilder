if @user
  json.state true
  json.message "密码修改成功"
  json.partial! "user", user: @user
else
  json.state false
  json.message "密码修改失败"
end
  
  

