# require 'rubygems'
# require 'rufus/scheduler'
# scheduler = Rufus::Scheduler.start_new
# 
# scheduler.every("2s") do
#    puts Time.now
# end
# 
# # 每天早上10:10，将订单提示支付记录的短信发出  
# scheduler.cron '10 10 * * *' do  
#   system("rake sms:send_tip_pay_messages RAILS_ENV=production")  
# end  
#   
# scheduler.join  # 要放上这个来居启动线程，而在初始化目录中是由rails启动时顺带启动的


require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new





scheduler.every '30s' do
  # p "Predict.b"
  # Predict.b
end



#每日8点 
scheduler.in '8h' do
  # 更新所有商品明日预测价
  # Product.all.each do |product|
  #   if product.prices.last
  #     product.prices.last.set_tomorrow_forecast_cost
  #     product.update_attributes cost: (product.prices.last.forecast_cost * 100).round/100.0
  #   end
  # end
end



#每日4点 
scheduler.in '2h' do
  #更新用户订购预测
  User.all.each do |user|
    user.update_predict
  end
end

scheduler.in '4h' do
  #更新用户订购预测
  Product.do_order_total
end




# scheduler.join
  # let the current thread join the scheduler thread