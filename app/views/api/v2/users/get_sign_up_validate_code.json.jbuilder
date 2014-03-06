if @user
  json.state false
  json.message "此手机已注册"
else
  json.state true
  json.validate_code @validate_code
  json.message "验证码已发送"
end
  
  

