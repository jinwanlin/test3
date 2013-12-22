# encoding: utf-8
module UsersHelper
  
  def user_state(state)
    case state
      when "pending" then "注册中"
      when "unaudited" then "未审核"
      when "actived" then "正常"
      when "freezed" then "冻结"
    end
  end
end
