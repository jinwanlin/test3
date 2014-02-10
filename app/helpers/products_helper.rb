# encoding: utf-8
module ProductsHelper
  
  def order_amount(order, product)
    if @order
      order.order_items.each do |order_item|
        return order_item.order_amount if order_item.product_id == product.id
      end
    end
    0
  end
  
  

  
end
