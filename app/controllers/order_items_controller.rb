class OrderItemsController < ApplicationController
  load_and_authorize_resource class: 'OrderItem'
  
  def index
    @order_items = OrderItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @order_items }
    end
  end

  def show
    @order_item = OrderItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order_item }
    end
  end


  def create
    
    # order
    if current_user.admin? && params[:order_item][:order_id].present?
      @order = Order.find(params[:order_item][:order_id])
    else
      @order = current_user.orders.last
      if @order && (@order.pending? || @order.confirmed?)
        @order.continue_buy if @order.confirmed?      
      else
        @order = current_user.orders.create
      end
    end
    
    # product
    if params[:order_item][:product_id].present?
      product = Product.find params[:order_item][:product_id]
    else
      product = Product.find_by_name params[:product_name]
    end
    
    
    # order_item
    @old_order_item = @order.order_items.where(product_id: product).first
    if @old_order_item
      # @order_item.order_amount = params[:order_item][:order_amount]
    else
      @order_item = @order.order_items.new(params[:order_item])
      @order_item.product = product
      @order_item.price = product.sales_price(@order_item.order.user.level)
      @order_item.cost = product.prices.last.actual_cost unless product.prices.empty? 
      
      date = Date.today
      date = date-1.days if Time.new.hour < 3 # 凌晨3点前任然显示昨天的价格
    
      predict = Predict.where(user_id: current_user).where(date: date).where(product_id: product).first
      predict.update_attributes order_amount: params[:order_item][:order_amount] if predict
    end
    
    
    
    respond_to do |format|
      unless @old_order_item
        @order_item.order_amount==0 ? @order_item.destroy : @order_item.save
      end
      
      format.html { redirect_to @order }
      format.js
      format.json
    end
  end

  def update
    @order_item = OrderItem.find(params[:id])

    respond_to do |format|
      if @order_item.update_attributes(params[:order_item])
        format.html { redirect_to @order_item, notice: 'Order item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit_amount
    @order_item = OrderItem.find(params[:id])
  end
  
  def save_amount
    @order_item = OrderItem.find(params[:id])
    @order_item.update_attributes order_amount: params[:order_item][:order_amount]
    
    predict = Predict.where(user_id: current_user).where(product_id: @order_item.product).first
    predict.update_attributes order_amount: params[:order_item][:order_amount] if predict
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy

    respond_to do |format|
      format.html { redirect_to @order_item.order }
      format.json { head :no_content }
      format.js
    end
  end
end
