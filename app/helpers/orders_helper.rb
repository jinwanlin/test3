# encoding: utf-8
module OrdersHelper
  
  def order_state(state)
    case state
      when "pending" then "未提交"
      when "open" then "待出库"
      when "ship" then "已出库"
      when "canceled" then "已取消"
      when "done" then "已完成"
    end
  end
  
end
