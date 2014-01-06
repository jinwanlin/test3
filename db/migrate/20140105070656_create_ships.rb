class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :sn
      t.references :order
      t.references :order_item
      t.references :product
      t.float :amount, :null => false
      
      t.timestamps
    end
  end
end
