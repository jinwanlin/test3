if order_item
    json.id order_item.id
    json.product_id order_item.product_id
    json.product_name order_item.product.name
    json.product_unit "斤"
    json.order_id order_item.order_id
    json.order_state order_item.order.state
    
    json.price order_item.price #单价
    
    json.order_amount order_item.order_amount #订购量
    json.ship_amount order_item.ship_amount ? order_item.ship_amount : 0 #出货量
    json.order_sum order_item.order_sum #订购金额
    json.ship_sum order_item.ship_sum #出货金额
    
    json.created_at order_item.created_at
    json.updated_at order_item.updated_at
end