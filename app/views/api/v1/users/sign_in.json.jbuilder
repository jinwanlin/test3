json.state !@user.nil?
json.message @message
json.partial! "user", user: @user