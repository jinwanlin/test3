class OrdersController < ApplicationController
  before_filter :find_order, only: [:show ,:edit, :update, :destroy, :submit, :cancel, :ship, :done, :print]
  
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
  end
  

  
  
  
  
  def submit
    @order.submit
    redirect_to @order
  end
  
  def print_order
    
  end
  
  def print_ship
    @order.shipment
    redirect_to @order
  end
  
  def loading
    
  end
  
  def sign
    
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
