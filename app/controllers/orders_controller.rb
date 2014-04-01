class OrdersController < ApplicationController
  load_and_authorize_resource class: 'Order'
  
  before_filter :find_order, only: [:show ,:edit, :update, :destroy, :submit,  :continue_buy,  :print_ship,  :loading,  :sign,  :done,  :cancel]
  
  
  def index
    @orders = Order.all
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
  end

  def update
    @order.update_attributes(params[:order])
  end

  def destroy
    @order.destroy
    redirect_to orders_path
  end


  
  def submit
    @order.submit
    redirect_to @order
  end
  
  def continue_buy
    @order.continue_buy  if order.confirmed?
    redirect_to @order
  end
  
  def print_order
    # @order.print_order
    # redirect_to @order
    p params[:sn]
    @orders = Order.where("id IN (?)", params[:sn])
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
    @order.cancel
    redirect_to @order
  end
  




  private
  def find_order
    @order = Order.find(params[:id])
  end
   
end
