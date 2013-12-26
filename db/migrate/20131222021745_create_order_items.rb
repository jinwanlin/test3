class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :product
      t.references :order
      t.float :price
      t.integer :order_amount
      t.float :ship_amount
      t.float :sum
      t.float :cost
      t.float :cost_sum
      
      t.timestamps
    end
  end
end
