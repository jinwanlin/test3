# encoding: utf-8
# 用户明日订购预测
class Predict < ActiveRecord::Base
  # default_scope :order => 'order_times DESC'
  
  belongs_to :user
  belongs_to :product
  attr_accessible :average_amount, :order_amount, :order_times, :date, :user, :user_id, :product, :product_id, :updated_at
  

  def self.update_user(user)
    today = Date.today
    
    order_ids = Order.where(user_id: user).where(:state => ['shiping', 'baled', 'truck', 'signed', 'done']).where("created_at > ?", today-8.days).where("created_at < ?", today+1.days).pluck(:id)
    Product.where(state: 'up').each do |product|
      update_product_user(user, today, order_ids, product)
    end
    Predict.where(user_id: user).where("updated_at < ?", Time.now-10.seconds).delete_all
  end
  
  def self.update_product_user(user, today, order_ids, product)
    return if product.prices.empty?
    
    average_amount = 0
    order_times = 0
    unless order_ids.empty?
      if order_ids.size > 1
        items = OrderItem.where(:order_id => order_ids).where(product_id: product)
        unless items.empty?
          amount_total = 0
          items.each do |item|
            amount_total += item.order_amount
          end
          average_amount = amount_total*1.0/items.size
          order_times = items.size
        end
      else
        item = OrderItem.where("order_id = ?", order_ids).where(product_id: product).first
        average_amount = item ? item.order_amount : 0
        order_times = item ? 1 : 0
      end
      
    end
    predict = Predict.where(user_id: user, product_id: product).try :first
    if predict
      predict.update_attributes date: today, average_amount: average_amount, order_times: order_times, updated_at: Time.now
    else
      Predict.create user: user, product: product, date: today, average_amount: average_amount, order_times: order_times, order_amount: 0, updated_at: Time.now
    end
  end
end
