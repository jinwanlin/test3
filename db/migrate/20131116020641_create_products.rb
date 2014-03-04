# encoding: utf-8
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :sn #商品编号
      t.string :name
      t.string :aliases #别名
      t.string :type #分类
      t.integer :classify #归类
      t.integer :no #归类里的序号
      t.string :amounts #可选重量
      t.string :state #状态：上架、下架、归档  ActiveRecord::Migration.add_column :products, :state, :string, default: 'down'
      t.integer :series, :default => 1 # 分组，用于作涨价先后次序
      t.float :cost, :null => false, :default => 0.0 # 当前平均成本
      t.text :des

      t.timestamps
    end
  end
end
