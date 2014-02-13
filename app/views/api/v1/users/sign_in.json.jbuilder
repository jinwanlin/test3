json.status !@user.nil?
json.message @message
json.partial! "user", user: @user