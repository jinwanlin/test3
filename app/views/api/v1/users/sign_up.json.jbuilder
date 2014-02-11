if @user
  json.state true
  json.need_validate Settings.has_validate_code
  json.user do
    json.id @user.id
    json.name @user.phone
  end
else
  json.state false
  json.message "手机号已注册，请登录或找回密码。"
end