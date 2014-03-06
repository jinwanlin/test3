if @user
  json.state true
  json.validate_code @validate_code
  json.message "验证码已发送"
else
  json.state false
  json.message "此手机已注册"
end
  
  

