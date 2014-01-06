class ShipsController < ApplicationController


  def create
    @ship = Ship.new(params[:ship])
    
    product = Product.find(1)
    @ship.product = product
    
    @order_item = @ship.order.order_items.where(product_id: product).first
    @ship.order_item = @order_item
    
    @ship.amount = 3.3

    respond_to do |format|
      if @ship.save
        format.js
      else
        format.js
      end
    end
  end


  def destroy
    @ship = Ship.find(params[:id])
    @destroy_success = @ship.destroy

    respond_to do |format|
      format.html { redirect_to @ship.order }
      format.js
    end
  end
end
