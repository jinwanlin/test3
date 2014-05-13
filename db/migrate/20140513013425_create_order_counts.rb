class CreateOrderCounts < ActiveRecord::Migration
  def change
    create_table :order_counts do |t|
      t.references :product
      t.float :amount
      t.date :date

      t.timestamps
    end
  end
end
