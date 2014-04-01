class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :product
      t.references :order
      t.integer :order_amount
      t.float :ship_amount, :null => false, :default => 0.0
      
      t.float :price, :null => false, :default => 0.0
      t.float :order_sum, :null => false, :default => 0.0
      t.float :ship_sum, :null => false, :default => 0.0
      
      t.float :cost, :null => false, :default => 0.0
      t.float :cost_sum, :null => false, :default => 0.0
      
      t.timestamps
    end
  end
end