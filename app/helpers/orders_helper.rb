# encoding: utf-8
module OrdersHelper
  
  def order_state(state)
    case state
      when "pending" then "未提交"
      when "confirmed" then "已确认待出库"
      when "shiping" then "订单已打印出库中"
      when "baled" then "打包完毕配送中"
      when "signed" then "已送达"
      when "done" then "交易成功"
      when "canceled" then "已取消"
    end
  end
  
end
