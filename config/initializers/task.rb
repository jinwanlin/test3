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



#每日8点 生成新预测价
scheduler.in '8h' do
  # do something every 8 hours
end



#每日4点 用户生成可能订购量 
scheduler.in '2h' do
  Predict.b
  # do something every 8 hours
end

# scheduler.join
  # let the current thread join the scheduler thread