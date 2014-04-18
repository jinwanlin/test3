# encoding: utf-8
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :sn #商品编号
      t.string :name
      t.string :aliases #别名
      t.string :type #分类
      t.string :classify #归类
      t.integer :no #归类里的序号
      t.string :market_area
      t.integer :market_sort
      t.string :amounts #可选重量
      t.integer :optional_amounts #可选重量
      t.string :unit # 计价单位：斤
      t.string :state #状态：上架、下架、归档  ActiveRecord::Migration.add_column :products, :state, :string, default: 'down'
      t.integer :series, :default => 1 # 分组，用于作涨价先后次序
      t.float :cost, :null => false, :default => 0.0 # 当前平均成本
      t.text :experience
      t.text :des
      t.float :order_total
      t.text :order_detail
      t.text :order_spid
      t.string :pinyin
      t.integer :save_time #保鲜时间
      
      t.timestamps
    end
  end
end
