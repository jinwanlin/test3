class CreatePredicts < ActiveRecord::Migration
  def change
    create_table :predicts do |t|
      t.date :date
      t.references :user
      t.references :product
      t.float :average_amount, :null => false, :default => 0.0
      t.integer :order_times
      t.float :order_amount

      t.timestamps
    end
    add_index :predicts, :user_id
    add_index :predicts, :product_id
  end
end
