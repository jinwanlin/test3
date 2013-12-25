class OrderItemsController < ApplicationController
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
    @order = current_user.orders.last
    if @order && (@order.pending? || @order.open?)
    else
      @order = current_user.orders.create
    end
    
    # product
    if params[:order_item][:product_id].present?
      product = Product.find params[:order_item][:product_id]
    else
      product = Product.find_by_name params[:product_name]
    end
    
    # order_item
    @order_item = @order.order_items.where(product_id: product).first
    if @order_item
      @order_item.order_amount = params[:order_item][:order_amount]
    else
      @order_item = @order.order_items.new(params[:order_item])
      @order_item.product = product
    end
    

    respond_to do |format|
      if @order_item.order_amount==0 ? @order_item.destroy : @order_item.save
        format.html { redirect_to @order }
        format.js
        format.json
      else
        format.js
        format.json
      end
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

  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy

    respond_to do |format|
      format.html { redirect_to @order_item.order }
      format.json { head :no_content }
    end
  end
end
