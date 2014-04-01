# encoding: utf-8
module OrdersHelper
  
  def order_state(state)
    Order::STATES[state]
    # case state
    #   when "pending" then "待提交"
    #   when "confirmed" then "待打印订单"
    #   when "shiping" then "待打印出库单"
    #   when "baled" then "待装车"
    #   when "truck" then "配送中"
    #   when "signed" then "已送达"
    #   when "done" then "交易成功"
    #   when "canceled" then "已取消"
    # end
  end
  
end
