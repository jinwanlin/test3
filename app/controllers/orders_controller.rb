# encoding: utf-8
class OrdersController < ApplicationController
  load_and_authorize_resource class: 'Order'
  
  before_filter :find_order, only: [:show ,:edit, :update, :destroy, :submit,  :continue_buy,  :print_ship,  :loading,  :sign,  :done,  :cancel]
  
  
  def index
    if current_user.admin?
      @orders = Order
    else
      @orders = Order.where(user_id: current_user)
    end
    @orders = @orders.order("id desc")
  end

  def show
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    @order = Order.new(params[:order])
    @order.save
    
    redirect_to @order
  end

  def update
    @order.update_attributes(params[:order])
  end

  def destroy
    @order.destroy
    redirect_to orders_path
  end

  
  def auto_make_order
    @order = current_user.orders.create
    
    predicts = Predict.where(user_id: current_user).where(date: Date.today)
    predicts.each do |predict|
      order_amount = sprintf('%.0f', predict.average_amount).to_i
      next if order_amount==0
      
      order_item = @order.order_items.new
      order_item.product = predict.product
      order_item.order_amount = order_amount
      order_item.price = predict.product.sales_price(current_user.level)
      order_item.save
      
      predict.update_attributes order_amount: order_amount
      
    end
    redirect_to products_path
  end
  
  def submit
    
    if @order.nil?
      @error_msg = "订单已被删除，提交失败。"
    elsif @order.pending?
      @order.submit
    elsif @order.confirmed?
      
    elsif @order.canceled?
      @error_msg = "订单已取消，确认失败。"
    else
      @error_msg = "订单已出库，确认失败。"
    end
    
    respond_to do |format|
      format.html {
        if params[:return] == 'orders'
          redirect_to orders_path
        else
          redirect_to @order
        end
      }
      format.js
    end

  end
  
  def continue_buy
    
    if @order.nil?
      @error_msg = "订单已被删除，修改失败。"
    elsif @order.pending?
      
    elsif @order.confirmed?
      @order.continue_buy 
    elsif @order.canceled?
      @error_msg = "订单已取消，不能修改。"
    else
      @error_msg = "订单已出库，不能修改。"
    end
    
    respond_to do |format|
      format.html {
        if params[:return] == 'orders'
          redirect_to orders_path
        else
          redirect_to @order
        end
      }
      format.js
    end
  end
 
  def print_order
    # @order.print_order
    # redirect_to @order
    @orders = Order.where("id IN (?)", params[:order_id])
    @orders.each do |order|
      order.print_order if order.confirmed?
    end
    render layout: "print"
  end
  
  def print_ship
    @order.print_ship
    redirect_to @order
  end
  
  def loading
    @order.loading
    redirect_to @order
  end
  
  def sign
    @order.sign
    redirect_to @order
  end
  
  def done
    @order.done
    redirect_to @order
  end
  
  def cancel
    if @order.nil?
      @error_msg = "订单已被删除，修改失败。"
    elsif @order.confirmed?
      @order.continue_buy 
    elsif @order.canceled?
      @error_msg = "订单已取消，不能修改。"
    else
      @error_msg = "订单已出库，不能修改。"
    end
    
    @order.cancel
    
    if params[:return] == "products"
      redirect_to products_path
    elsif params[:return] == 'orders'
      redirect_to orders_path
    else
      redirect_to @order
    end
  end
  




  private
  def find_order
    begin
      @order = Order.find(params[:id])
    rescue
    end
  end
   
end
