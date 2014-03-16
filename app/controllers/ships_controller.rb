class ShipsController < ApplicationController


  def create
    ship_sn = params[:ship][:sn]
    p ship_sn
    if ship_sn.length == 13
      begin
        amount = ship_sn[7,3].to_i + ship_sn[10,2].to_i / 100.0
        product = Product.find(ship_sn[1,6].to_i)
      rescue Exception=>e
      end
      p product
      
      if amount && product
        @ship = Ship.new(params[:ship])
        @ship.amount = amount
        @ship.product = product
        @ship.order_item = @ship.order.order_items.where(product_id: product).first
        @ship.save
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

