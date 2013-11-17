class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.references :product
      t.float :purchase_low_price
      t.float :purchase_price
      t.float :purchase_heigh_price
      t.float :selling_price

      t.date :date
      t.timestamps
    end
  end
end
