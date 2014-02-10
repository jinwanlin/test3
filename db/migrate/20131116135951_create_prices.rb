class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.references :product
      # t.float :purchase_low_price, :null => false, :default => 0.0
      # t.float :purchase_price, :null => false, :default => 0.0
      # t.float :purchase_heigh_price, :null => false, :default => 0.0
      # t.float :selling_price, :null => false, :default => 0.0
      

      t.float :actual_cost, :null => false, :default => 0.0
      t.float :forecast_cost, :null => false, :default => 0.0
      
      
      
      
      t.date :date
      t.timestamps
    end
  end
end
