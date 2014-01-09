class ShipsController < ApplicationController


  def create
    
    if params[:ship][:sn].length == 13
      begin
        ship_sn = params[:ship][:sn]
        amount = ship_sn[7,2].to_i + ship_sn[9,2].to_i / 100.0
        product = Product.find_by_sn(ship_sn[1,6])
      rescue Exception=>e
      end
      
      if amount && product
        @ship = Ship.new(params[:ship])
        @ship.amount = amount
        @ship.product = product
        @ship.order_item = @ship.order.order_items.where(product_id: product).first
      end
    end
    respond_to do |format|
      if @ship && @ship.save
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

