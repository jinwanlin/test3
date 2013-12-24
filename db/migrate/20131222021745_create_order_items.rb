class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :product
      t.references :order
      t.float :price
      t.integer :order_amount
      t.float :ship_amount
      
      t.timestamps
    end
  end
end
