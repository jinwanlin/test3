# encoding: utf-8
module OrdersHelper
  
  def order_state(state)
    if current_user.admin?
      Order::STATES[state]
    else
      case state
        when "pending" then "挑选商品"
        when "confirmed" then "等待配送"
        when "shiping" then "配送中"
        when "baled" then "配送中"
        when "truck" then "配送中"
        when "signed" then "已送达"
        when "done" then "交易成功"
        when "canceled" then "已取消"
      end
    end
  end
  
end
