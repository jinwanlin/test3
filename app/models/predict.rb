# encoding: utf-8
# 用户明日订购预测
class Predict < ActiveRecord::Base
  default_scope :order => 'order_times DESC'
  
  belongs_to :user
  belongs_to :product
  attr_accessible :average_amount, :order_amount, :order_times, :date, :user, :user_id, :product, :product_id
  
  def self.a(user)
    begin_update = Time.now
    today = Date.today
    # Predict.where(user_id: user).where(date: today).delete_all
    
    order_ids = Order.where(user_id: user).where(:state => ['shiping', 'baled', 'truck', 'signed', 'done']).where("created_at > ?", today-8.days).where("created_at < ?", today+1.days).pluck(:id)
    Product.where(state: 'up').each do |product|
      average_amount = 0
      order_times = 0
      unless order_ids.empty?
        # p "======product_id======== #{product.id} "
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
      # p "--------product:#{product.id}, average_amount:#{average_amount}"
      #Predict.create date: today, average_amount: average_amount, order_times: order_times, order_amount: 0
      predict = Predict.where(user_id: user, product_id: product).try :first
      if predict
        predict.update_attributes date: today, average_amount: average_amount, order_times: order_times
      else
        Predict.create user: user, product: product, date: today, average_amount: average_amount, order_times: order_times, order_amount: 0
      end
    end
    Predict.where(user_id: user).where("updated_at < ?", begin_update).delete_all
  end
  
  def self.b
    User.all.each do |user|
      a user
    end
  end
  
  
end
