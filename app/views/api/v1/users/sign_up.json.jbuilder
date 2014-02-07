if @user
  json.state true
else
  json.state false
  json.message "手机号已注册过，请登录或找回密码。"
end