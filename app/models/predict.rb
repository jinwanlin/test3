# encoding: utf-8
# 用户明日订购预测
class Predict < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  attr_accessible :average_amount, :order_amount, :order_times, :date, :user, :user_id, :product, :product_id
  
  def self.a(user)
    today = Date.today
    if Predict.where(user_id: user).where(date: today).empty?
      ids = Order.where(user_id: user).where(state: 'done').where("created_at > ?", today-8.days).where("created_at < ?", today).pluck(:id)
      Product.all.each do |product|
        average_amount = 0
        order_times = 0
        
        unless ids.empty?
          items = OrderItem.where("order_id in ?", ids).where(product_id: product)
          unless items.empty?
            amount_total = 0
            items.each do |item|
              amount_total += item.order_amount
            end
            average_amount = amount_total*1.0/items.size
            order_times = items.size
          end
        end
        Predict.create date: today, user: user, product: product, average_amount: average_amount, order_times: order_times, order_amount: 0
        
      end
    end
  end
  
  
end
