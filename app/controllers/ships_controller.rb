class ShipsController < ApplicationController
  load_and_authorize_resource class: 'Ship'

  def create
    if params[:ship][:sn].present?
      ship_sn = params[:ship][:sn]
      if ship_sn.length == 13
        begin
          amount = ship_sn[7,3].to_i + ship_sn[10,2].to_i / 100.0
          product = Product.find(ship_sn[1,6].to_i)
        rescue Exception=>e
        end
      end
    elsif params[:amount].present?
      product = Product.find(params[:product_id]) if params[:product_id].present?
      product = Product.find_by_sn(params[:product_sn]) if params[:product_sn].present?
      amount = params[:amount]
      params[:ship][:sn] = "2#{product.id.to_s.rjust(6, '0')}#{((params[:amount].to_i * 100).round).to_s.rjust(5, '0')}0"
      
    end
    
    order_item = Order.find(params[:ship][:order_id]).order_items.where(product_id: product).first if product
    
    if amount && product && order_item
      @ship = Ship.new(params[:ship])
      @ship.amount = amount
      @ship.product = product
      @ship.order_item = order_item
      @ship.save
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

