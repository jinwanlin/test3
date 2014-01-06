class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :type
      t.integer :series, :default => 1 # 分组，用于作涨价先后次序
      t.float :cost, :null => false, :default => 0.0 # 当前平均成本
      t.text :des

      t.timestamps
    end
  end
end
