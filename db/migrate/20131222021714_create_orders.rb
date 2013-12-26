class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :sn
      t.references :user
      t.text :desc
      t.string :state
      t.float :sum
      t.float :profit
      
      t.timestamps
    end

    add_index :orders, :user_id
    add_index :orders, :sn
  end
end